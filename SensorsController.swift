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

class SensorViewTableCell: UITableViewCell {
    
    @IBOutlet weak var sensorDescLabel: UILabel!
    @IBOutlet weak var sensorNameLabel: UILabel!
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
        var stmt: OpaquePointer? = nil
        let selectSQL = "SELECT * FROM sensors;"
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        while sqlite3_step(stmt) == SQLITE_ROW {
            let s:SensorObject = SensorObject()
            s.name = String(cString: sqlite3_column_text(stmt, 0))
            s.decsription = String(cString: sqlite3_column_text(stmt, 1))
            self.sensors.append(s)
        }
        sqlite3_finalize(stmt)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sensor = sensors[indexPath.row]
        
        let cell = sensorsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SensorViewTableCell
        cell.sensorNameLabel?.text = sensor.name
        cell.sensorDescLabel?.text = sensor.decsription
        return cell
    }
    
        
}

