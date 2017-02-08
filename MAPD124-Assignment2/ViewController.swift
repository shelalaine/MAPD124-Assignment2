//
//  ViewController.swift
//  MAPD124-Assignment2
//
//  Created by Shelalaine Chan on 2017-01-31.
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tasks = [Task]() {
        didSet {
            tableView.reloadData()
        }
    }
    let data: [String] = ["Task 1", "Task 2", "Task 3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Rows", for: indexPath) as! TaskTableViewCell
        cell.taskLabel.text = data[indexPath.row]
        cell.editButton.tag = indexPath.row
        return cell;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

//            if let cell = sender as? TaskTableViewCell {
//                let indexPath = tableView.indexPath(for: cell)
//
//                if let segueToEdit = segue.destination as? EditViewController {
//                    print(data[(indexPath?.row)!])
//                    segueToEdit.task = data[(indexPath?.row)!]
//                }
//            }
        if let segueToEdit = segue.destination as? EditViewController {

            if let identifier = segue.identifier {
                // Pass the identifier
                segueToEdit.titleLabel = identifier
                
                // Pass the reference to the new Task object
                switch identifier {
                case "AddSegue":
                    segueToEdit.task = "New Task"
                case "EditSegue":
                    if let cell = sender as? UIButton {
                        segueToEdit.task = data[cell.tag]
                    }
                default:
                    break
                }
            }
        }
    }
}

