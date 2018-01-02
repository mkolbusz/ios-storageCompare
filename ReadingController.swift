//
//  ReadingController.swift
//  storageComapre
//
//  Created by Michal Kolbusz on 1/2/18.
//  Copyright © 2018 Użytkownik Gość. All rights reserved.
//

import UIKit
import CoreData

class ReadingController: UIViewController, UITableViewDataSource {
    
    var readings:[NSManagedObject] = []
    @IBOutlet weak var readingsTableView: UITableView!
    
    override func viewDidLoad() {
        generateReadings(number: 10)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reading = readings[indexPath.row]
        
        let cell = readingsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //        cell.textLabel?.text = sensor.value(forKey: "name") as? String
        cell.textLabel?.text = reading.value(forKey: "value") as? String
        return cell
    }
    
    func generateReadings(number: Int) {
        
        for _ in 1...number {
            let value = randomFloat(min: 0, max: 100)
            let timestamp = generateRandomDate(daysBack: 365);
            self.save(value: value, timestamp: timestamp!)
        }
    }
    
    func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random() / 0xFFFFFFFF) * (max - min) + min)
    }

    func generateRandomDate(daysBack: Int)-> Date?{
        let day = arc4random_uniform(UInt32(daysBack))+1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = Int(day - 1)
        offsetComponents.hour = Int(hour)
        offsetComponents.minute = Int(minute)
        
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        return randomDate
    }
    
    func save(value: Float, timestamp: Date) {
        print("[Save] Value: \(value), Desc: \(timestamp)")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Reading", in: managedContext)!
        let reading = NSManagedObject(entity: entity, insertInto: managedContext)
        
        reading.setValue(value, forKey: "value")
        reading.setValue(timestamp, forKey: "timestamp")
        
        do {
            try managedContext.save()
            readings.append(reading)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
