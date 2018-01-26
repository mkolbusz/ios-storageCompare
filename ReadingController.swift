//
//  ReadingController.swift
//  storageComapre
//
//  Created by Michal Kolbusz on 1/2/18.
//  Copyright © 2018 Użytkownik Gość. All rights reserved.
//

import UIKit
import CoreData


class ReadingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var sensorNameLabel: UILabel!
    @IBOutlet weak var readingValueLabel: UILabel!
}


class ReadingController: UIViewController, UITableViewDataSource {
    
    var readings:[NSManagedObject] = []
    @IBOutlet weak var readingsTableView: UITableView!
    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadReadings()
        readingsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reading = readings[indexPath.row]
        
        let cell = readingsTableView.dequeueReusableCell(withIdentifier: "ReadingCell", for: indexPath) as! ReadingTableViewCell
        cell.readingValueLabel?.text = String(describing: reading.value(forKey: "value")!)
        let sensor:NSManagedObject = reading.value(forKey: "sensor") as! NSManagedObject
        
        
        cell.sensorNameLabel?.text = String(describing: sensor.value(forKey: "name")!)
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.timestampLabel?.text = df.string(for: reading.value(forKey: "timestamp"))
        return cell
    }
    
    
    func loadReadings() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reading")
        
        do {
            readings = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

    }
    
    
        
}
