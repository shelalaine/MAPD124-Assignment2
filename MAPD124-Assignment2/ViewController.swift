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
    
    var tasks = [Task]()

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
        
        // Read the tasks from the database
        readTasksFromDB()
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
                    let newTask = Task(name:"", id:nil, "", true)
                    if let id = insertTaskToDB(task: newTask) {
                        newTask.id = id
                        // Append this task
                        tasks.append(newTask)
                        segueToEdit.task = tasks[tasks.count - 1]
                        // Save the index of the current Task
                        taskIndex = tasks.count - 1
                    }
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
        deleteTaskFromDB(index: tasks[indexPath.row].id!)
        tasks.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .fade)
    }
    
    func saveItem(controller: EditViewController, _ task: Task) {
        tasks[taskIndex!] = task
        updateTaskInDB(task: tasks[taskIndex!])
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
    
    
    //
    func insertTaskToDB(task: Task) -> Int? {
        var id: Int?
        
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        
        if result !=  SQLITE_OK {
            print("Failed to open database")
        } else {
            var statement:OpaquePointer? = nil
            let update = "INSERT OR REPLACE INTO FIELDS (TASK_DATA, TASK_NOTE) VALUES (?, ?);"
            
            if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
                let taskName = task.name as NSString
                let taskNote = task.notes as NSString
                
                sqlite3_bind_text(statement, 1, taskName.utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, taskNote.utf8String, -1, nil)
                
                print("Write: \(taskName), Note \(taskNote)")
            }
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error updating table")
            } else {
                sqlite3_finalize(statement)
                id = Int(sqlite3_last_insert_rowid(database))
            }
        }
        sqlite3_close(database)
        
        return id
    }
    
    // Read the tasks from the Task table SQL Table
    func readTasksFromDB() {
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        
        if result !=  SQLITE_OK {
            print("Failed to open database")
        } else {
            let query = "SELECT * FROM FIELDS ORDER BY ID;"
            var statement:OpaquePointer? = nil
            
            if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let row = Int(sqlite3_column_int(statement, 0))
                    let rowData = sqlite3_column_text(statement, 1)
                    let rowNote = sqlite3_column_text(statement, 2)
                    let fieldValue = String.init(cString: rowData!)
                    let fieldNoteValue = String.init(cString: rowNote!)
                    tasks.append(Task(name: fieldValue, id:row, fieldNoteValue, true))
                    
                    print("Read: \(row), \(fieldValue), \(fieldNoteValue)")
                }
                
                sqlite3_finalize(statement)
            }
        }
        
        sqlite3_close(database)
    }
    
    // Delete task from the SQL Database
    func deleteTaskFromDB(index: Int) {
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        
        if result !=  SQLITE_OK {
            print("Failed to open database")
        } else {
            let query = "DELETE FROM FIELDS WHERE ID = " + String(index) + ";"
            var statement:OpaquePointer? = nil
            
            if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Deleted task, ID \(index)")
                }
                
                sqlite3_finalize(statement)
            }
        }
        
        sqlite3_close(database)
    }
    
    // Update task in the SQL database
    func updateTaskInDB(task: Task) {
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        
        if result !=  SQLITE_OK {
            print("Failed to open database")
        } else {
            let query = "UPDATE FIELDS SET TASK_DATA = '" + task.name +
                        "', TASK_NOTE = '" + task.notes +
                        "' WHERE ID = " + String(task.id!) + ";"
            var statement:OpaquePointer? = nil
            
            if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Updated task, ID \(task.id!)")
                }
                
                sqlite3_finalize(statement)
            }
        }
        
        sqlite3_close(database)
    }
}

