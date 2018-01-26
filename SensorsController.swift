//
//  ViewController.swift
//  storageComapre
//
//  Created by Użytkownik Gość on 08.12.2017.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit
import CoreData

class SensorObject {
    var name: String = ""
    var decsription: String = ""
}

class ReadingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sensorNameLabel: UILabel!
    @IBOutlet weak var readingValueLabel: UILabel!
}

class SensorsController: UIViewController, UITableViewDataSource {
    
    
    var db: OpaquePointer? = nil
    @IBOutlet weak var sensorsTableView: UITableView!
    var sensors: [SensorObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Sensors List"
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("demo.db")?.path
        
        if sqlite3_open(dbFilePath, &db) == SQLITE_OK {
            print("ok")
        } else {
            print("fail")
        }

        loadSensors();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    func loadSensors() {
        let selectSQL = "SELECT * FROM sensors"
        sqlite3_exec(db, selectSQL,
                     {_, columnCount, values, columns in
                        print("Next record")
                        for i in 0 ..< Int(columnCount) {
                            let s :SensorObject
                            s.name = String(cString: columns![i]!)
                            s.decsription = String(cString: values![i]!)
                            print("  \(s.name):\(s.decsription)")
                        }
                        return 0
        }, nil, nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sensor = sensors[indexPath.row]
        
        let cell = sensorsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SensorViewTableCell
//        cell.textLabel?.text = sensor.value(forKey: "name") as? String
        cell.sensorNameLabel?.text = sensor.name
        cell.sensorDescLabel?.text = sensor.decsription
        return cell
    }
    
        
}

