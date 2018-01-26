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
    
    @IBOutlet weak var sensorNameLabel: UILabel!
    @IBOutlet weak var readingValueLabel: UILabel!
}


class ReadingController: UIViewController, UITableViewDataSource {
    
    var db: OpaquePointer? = nil
    var readings:[ReadingObject] = []
    @IBOutlet weak var readingsTableView: UITableView!
    
    override func viewDidLoad() {
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("demo.db")?.path
        
        if sqlite3_open(dbFilePath, &db) == SQLITE_OK {
            print("ok")
        } else {
            print("fail")
        }

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
        cell.readingValueLabel?.text = String(reading.value)
        cell.sensorNameLabel?.text = reading.sensor_name
        return cell
    }
    
    
    func loadReadings() {
        self.readings.removeAll()
        var stmt: OpaquePointer? = nil
        let selectSQL = "SELECT value, timestamp, sensor_name FROM readings;"
        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        while sqlite3_step(stmt) == SQLITE_ROW {
            let s:ReadingObject = ReadingObject()
            s.value = Float(sqlite3_column_double(stmt, 0))
            //s.timestamp = String(cString: sqlite3_column_text(stmt, 1))
            s.sensor_name = String(cString: sqlite3_column_text(stmt, 2)) + " : " + String(cString: sqlite3_column_text(stmt, 1))
            self.readings.append(s)
        }
        sqlite3_finalize(stmt)
    }
    
    
        
}
