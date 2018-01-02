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
    
    
    @IBOutlet weak var tableView: UITableView!
    var sensors: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Home"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            }
    
   
    
    
    
    
    @IBAction func generateData(_ sender: UIButton) {

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sensor = sensors[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = sensor.value(forKey: "name") as? String
        return cell
    }
    
    func save(name: String, description: String) {
        print("Home")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Sensor", in: managedContext)!
        let sensor = NSManagedObject(entity: entity, insertInto: managedContext)
        
        sensor.setValue(name, forKey: "name")
        sensor.setValue(description, forKey: "description")
        
        do {
            try managedContext.save()
            sensors.append(sensor)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
     }
    
}

