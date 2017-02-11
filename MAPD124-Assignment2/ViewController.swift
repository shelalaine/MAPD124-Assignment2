//
//  ViewController.swift
//  MAPD124-Assignment2
//
//  Created by Shelalaine Chan on 2017-01-31.
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, EditViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var taskIndex: Int?
    
    var tasks = [Task]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the predefined tasks
        tasks.append(Task(name: "Do Web App Assignment", "", true))
        tasks.append(Task(name: "Do Assignment 2", "", true))
        tasks.append(Task(name: "Prepare for the Emerging Tech presentation", "", false))
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Rows", for: indexPath) as! TaskTableViewCell
        cell.taskLabel.text = tasks[indexPath.row].name
        cell.completedSwitch.setOn(tasks[indexPath.row].onGoing, animated: false)
        cell.editButton.tag = indexPath.row
        return cell;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
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
                
                // Assign self to the EditViewController delegate
                segueToEdit.delegate = self
                
                // Pass the reference to the new Task object
                switch identifier {
                case "AddSegue":
                    tasks.append(Task(name:"", "", true))
                    segueToEdit.task = tasks[tasks.count - 1]
                    // Save the index of the current Task
                    taskIndex = tasks.count - 1
                case "EditSegue":
                    if let cell = sender as? UIButton {
                        segueToEdit.task = tasks[cell.tag]
                        // Save the index of the current Task
                        taskIndex = cell.tag
                    }
                default:
                    break
                }
                

            }
        }
    }
    
    func saveItem(controller: EditViewController, _ task: Task) {
        tasks[taskIndex!] = task
        print("\(tasks[taskIndex!].name) ")
    }
}

