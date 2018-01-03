//
//  ViewController.swift
//  storageComapre
//
//  Created by Użytkownik Gość on 08.12.2017.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit
import CoreData

class SensorViewTableCell: UITableViewCell {
   
    @IBOutlet weak var sensorDescLabel: UILabel!
    @IBOutlet weak var sensorNameLabel: UILabel!
}

class SensorsController: UIViewController, UITableViewDataSource {
    
    
    
    @IBOutlet weak var sensorsTableView: UITableView!
    var sensors: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Sensors List"
        
        loadSensors();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(sensors.isEmpty) {
            generateSensors(number: 20)
        }
        
        
    }
    
    func loadSensors() {
        print("Sensors' loading")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Sensor")
        
        do {
            sensors = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for sensor in sensors {
            print("[Sensor] \(String(describing: sensor.value(forKey: "name"))), \(String(describing: sensor.value(forKey: "desc")))")
        }
        sensorsTableView.reloadData()
    }
    
    func generateSensors(number: Int) {
        print("generating sensors");
        for n in 1...number {
            let name = "S" + (n > 9 ? String(n) : "0"+String(n))
            let description = "Sensor number " + String(n)
            self.save(name: name, description: description)
        }
        print("generating sensors - end");
    }
    
    
    
    
    @IBAction func generateData(_ sender: UIButton) {
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sensor = sensors[indexPath.row]
        
        let cell = sensorsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SensorViewTableCell
//        cell.textLabel?.text = sensor.value(forKey: "name") as? String
        cell.sensorNameLabel?.text = sensor.value(forKey: "name") as? String
        cell.sensorDescLabel?.text = sensor.value(forKey: "desc") as? String
        return cell
    }
    
    func save(name: String, description: String) {
        print("[Save] Name: \(name), Desc: \(description)")
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
            sensors.append(sensor)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

