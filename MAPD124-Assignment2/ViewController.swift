//
//  ViewController.swift
//  MAPD124-Assignment2
//
//  Created by Shelalaine Chan on 2017-01-31.
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, EditViewControllerDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var addUIBarButton: UIBarButtonItem!
    var taskIndex: Int?
    
    var tasks = [Task]() {
        didSet {
//            table.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add an Edit button to allow deletion of cell
//        self.navigationItem.leftBarButtonItem = editButtonItem
        
        // Open the database
        var database:OpaquePointer? = nil

        if sqlite3_open(dataFilePath(), &database) != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        
        // Create the table
        let createSQL = "CREATE TABLE IF NOT EXISTS FIELDS " +
                        "(ID INTEGER PRIMARY KEY AUTOINCREMENT, TASK_DATA TEXT, TASK_NOTE TEXT);"
        var errMsg:UnsafeMutablePointer<Int8>? = nil

        if (sqlite3_exec(database, createSQL, nil, nil, &errMsg) != SQLITE_OK) {
            sqlite3_close(database)
            print("Failed to create table")
            return
        }
        
        let query = "SELECT ID, TASK_DATA, TASK_NOTE FROM FIELDS ORDER BY ID"
        var statement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
//                let row = Int(sqlite3_column_int(statement, 0))
                let rowData = sqlite3_column_text(statement, 1)
                let rowNote = sqlite3_column_text(statement, 2)
                let fieldValue = String.init(cString: rowData!)
                let fieldNoteValue = String.init(cString: rowNote!)
                tasks.append(Task(name: fieldValue, fieldNoteValue, true))
            }
            
            sqlite3_finalize(statement)
        }
        
        sqlite3_close(database)
        
    
        let app = UIApplication.shared
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.applicationWillResignActive(notification:)),
                                               name: Notification.Name.UIApplicationWillResignActive,
                                               object: app)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.table.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Rows", for: indexPath) as! TaskTableViewCell
        cell.taskLabel.text = tasks[indexPath.row].name
        cell.subTaskLabel.text = tasks[indexPath.row].notes
        cell.completedSwitch.setOn(tasks[indexPath.row].onGoing, animated: false)
        cell.editButton.tag = indexPath.row
        return cell;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

//            if let cell = sender as? TaskTableViewCell {
//                let indexPath = table.indexPath(for: cell)
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
        
        addUIBarButton.isEnabled = !table.isEditing
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Remove the task of the tableview selected
        tasks.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .fade)
    }
    
    func saveItem(controller: EditViewController, _ task: Task) {
        tasks[taskIndex!] = task
        print("\(tasks[taskIndex!].name) ")
    }
    
    
    // MARK: SQLite Handlers
    
    func dataFilePath() -> String {
        let urls = FileManager.default.urls(for:
            .documentDirectory, in: .userDomainMask)
        var url:String?
        url = urls.first?.appendingPathComponent("taskdata.plist").path
        return url!
    }
    
    func applicationWillResignActive(notification: NSNotification) {
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        
        if result !=  SQLITE_OK {
            print("Failed to open database")
        } else {
            for index in 0..<tasks.count {
                let task = tasks[index]
                let update = "INSERT OR REPLACE INTO FIELDS (ID, TASK_DATA, TASK_NOTE) " +
                                "VALUES (?, ?, ?);"
                var statement:OpaquePointer? = nil
                
                if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
                    sqlite3_bind_int(statement, 1, Int32(index))
                    sqlite3_bind_text(statement, 2, task.name, -1, nil)
                    sqlite3_bind_text(statement, 3, task.notes, -1, nil)
                }
                
                if sqlite3_step(statement) != SQLITE_DONE {
                    print("Error updating table")
                } else {
                    sqlite3_finalize(statement)
                }
            }
        }
        sqlite3_close(database)
    }
    
}

