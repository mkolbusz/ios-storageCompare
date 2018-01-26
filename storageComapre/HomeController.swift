//
//  ViewController.swift
//  storageComapre
//
//  Created by Użytkownik Gość on 08.12.2017.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    var db: OpaquePointer? = nil
    
    @IBOutlet weak var resultsTextView: UITextView!
    @IBOutlet weak var numberTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("demo.db")?.path
        
        if sqlite3_open(dbFilePath, &db) == SQLITE_OK {
            createTableIfNotExists()
        } else {
            print("fail")
        }
        
        self.generateSensors(number: 20)
        // Do any additional setup after loading the view, typically from a nib.
        title = "Home"
    }
    
    func createTableIfNotExists() {
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS sensors (name TEXT NOT NULL PRIMARY KEY, description TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table 'sensors': \(errmsg)")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS readings (value TEXT NOT NULL PRIMARY KEY, description TEXT, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP, sensor_name TEXT NOT NULL, FOREIGN KEY(sensor_name) REFERENCES sensors(name))", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table 'readings': \(errmsg)")
        }
    }
    
    
    func generateReadings(number: Int) {
        let startTime = NSDate()
        for _ in 1...number {
            let value = randomFloat(min: 0.0, max: 100.0)
            let timestamp = generateRandomDate(daysBack: 365)
            self.saveReading(value: value, timestamp: timestamp!)
        }
        let finishTime = NSDate()
        let measuredTime = finishTime.timeIntervalSince(startTime as Date)
        print("generateReadings: \(measuredTime)")
    }
    
    
    @IBAction func generateData(_ sender: UIButton) {
        let number = Int((numberTxt?.text)!)
        self.generateReadings(number: number!)
    }
    
    @IBAction func clearReadings(_ sender: UIButton) {

        
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
        
    }
    
    @IBAction func findLargestAndSmallestReading(_ sender: UIButton) {
    
    }
    
    
    @IBAction func averageOfAllReadings(_ sender: UIButton) {


    }
    
    @IBAction func averageGroupedBySensor(_ sender: Any) {
  
    }
    
    // SENSORS
    func generateSensors(number: Int) {
        if(self.checkIfSensorsGenerated()){
            return
        }
        
        var insertSQL = "BEGIN TRANSACTION;";
        for n in 1...number {
            let name = "S" + (n > 9 ? String(n) : "0"+String(n))
            let description = "Sensor number " + String(n)
            insertSQL.append("INSERT INTO sensors (name, description) VALUES ('\(name)', '\(description)');")
        }
        insertSQL.append("COMMIT;")
        sqlite3_exec(db, insertSQL, nil, nil, nil)
        
        
    }

    func checkIfSensorsGenerated() -> Bool {
        
            return false
    }
    
}

