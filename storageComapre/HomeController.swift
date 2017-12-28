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
    
    
    @IBAction func generateData(_ sender: UIButton) {
        let n = ["Anna", "Jan", "Krzysztof", "Robert", "Natalia", "Maja", "Julia"];
        for name in n {
            sensors.append(name: name)
        }
        tableView.reloadData()
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
    
}

