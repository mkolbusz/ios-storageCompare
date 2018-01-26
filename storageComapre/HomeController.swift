//
//  ViewController.swift
//  storageComapre
//
//  Created by Użytkownik Gość on 08.12.2017.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit
import CoreData

class HomeController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var resultsTableView: UITableView!
    
    @IBOutlet weak var numberTxt: UITextField!
    
    var results: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generateSensors(number: 20)
        // Do any additional setup after loading the view, typically from a nib.
        title = "Home"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    
    func generateReadings(number: Int) {
        for _ in 1...number {
            let value = randomFloat(min: 0.0, max: 100.0)
            let timestamp = generateRandomDate(daysBack: 365)
            self.saveReading(value: value, timestamp: timestamp!)
        }
    }
    
    
    @IBAction func generateData(_ sender: UIButton) {
        print("Generating")
        let number = Int((numberTxt?.text)!)
        self.generateReadings(number: number!)
    }
    
    @IBAction func clearReadings(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(request)
        } catch let error as NSError {
            print("Could not delete: \(error), \(error.userInfo)")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ReadingTableViewCell
        cell.readingValueLabel?.text = String(describing: result.value(forKey: "value")!)
        let sensor:NSManagedObject = result.value(forKey: "sensor") as! NSManagedObject
        
        cell.sensorNameLabel?.text = String(describing: sensor.value(forKey: "name")!)
        return cell
    }
    
    func randomFloat(min: Float, max: Float) -> Float {
        return ((Float(arc4random()) / Float(UInt32.max)) * (max - min) + min)
    }
    
    func generateRandomDate(daysBack: Int)-> Date?{
        let day = arc4random_uniform(UInt32(daysBack))+1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        
        let today = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = Int(day - 1)
        offsetComponents.hour = Int(hour)
        offsetComponents.minute = Int(minute)
        
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        return randomDate
    }
    
    func saveReading(value: Float, timestamp: Date) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Reading", in: managedContext)!
        let reading = NSManagedObject(entity: entity, insertInto: managedContext)
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Sensor")
        
        do {
            let sensors = try managedContext.fetch(fetchRequest)
            let index = Int(arc4random_uniform(UInt32(sensors.count)))
            if let sensor = sensors[index] as NSManagedObject? {
                reading.setValue(value, forKey: "value")
                reading.setValue(timestamp, forKey: "timestamp")
                reading.setValue(sensor, forKey: "sensor")
            }
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    @IBAction func findLargestAndSmallestReading(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reading")
        
        let maxP = NSPredicate(format: "value==max(value)")
        let minP = NSPredicate(format: "value==min(value)")
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [maxP, minP])
        do {
            results = try managedContext.fetch(fetchRequest)
            resultsTableView.reloadData()
        }catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
    
    @IBAction func averageOfAllReadings(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Reading")
        fetchRequest.resultType = .dictionaryResultType
        
        let ex = NSExpression(forFunction: "average:", arguments: [NSExpression(forKeyPath: "value")])
        let exDesc = NSExpressionDescription()
        exDesc.name = "avgValue"
        exDesc.expression = ex
        exDesc.expressionResultType = .floatAttributeType
        
        fetchRequest.propertiesToFetch = [exDesc]
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            results.removeAll()
            let o:NSManagedObject = NSManagedObject
            o.setValue(result.first!.value(forKey: "avgValue"), forKey: "value")
            results.append(o)
        }catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }

    }
    
    // SENSORS
    func generateSensors(number: Int) {
        if(self.checkIfSensorsGenerated()){
            return
        }
        
        for n in 1...number {
            let name = "S" + (n > 9 ? String(n) : "0"+String(n))
            let description = "Sensor number " + String(n)
            self.saveSensor(name: name, description: description)
        }
    }
    
    func saveSensor(name: String, description: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Sensor", in: managedContext)!
        let sensor = NSManagedObject(entity: entity, insertInto: managedContext)
        
        sensor.setValue(name, forKey: "name")
        sensor.setValue(description, forKey: "desc")
        
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func checkIfSensorsGenerated() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Sensor")
        
        do {
            let number = try managedContext.count(for: fetchRequest)
            return number  > 0 ? true : false
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return false
    }
    
}

