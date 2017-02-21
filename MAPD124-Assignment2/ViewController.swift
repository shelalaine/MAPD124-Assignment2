//
//  File Name:      ViewController.swift
//  Project Name:   MAPD124-Assignment2
//  Description:    This is the main UI View Controller of all tasks
//
//  Created by:     Shelalaine Chan 
//  Student ID:     300924281
//  Change History: 2017-01-31, Created
//                  2017-02-20, Added SQLite3 storage support
//                              Implemented SettingCellDelegate and EditViewControllerDelegate
//                              Bug fixes
//
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
                        UITableViewDataSource,
                        SettingCellDelegate,
                        EditViewControllerDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var addUIBarButton: UIBarButtonItem!
    
    var taskIndex: Int?
    var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Open the database
        var database:OpaquePointer? = nil

        if sqlite3_open(dataFilePath(), &database) != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        
        // Create the table
        let createSQL = "CREATE TABLE IF NOT EXISTS FIELDS " +
                        "(ID INTEGER PRIMARY KEY AUTOINCREMENT, TASK_DATA TEXT, TASK_NOTE TEXT, ONGOING INT);"
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
        // Refresh the tasks table to ensure that latest changes are applied
        self.table.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Rows", for: indexPath) as! TaskTableViewCell
        updateTaskLabels(cell, indexPath.row)
        cell.completedSwitch.setOn(tasks[indexPath.row].onGoing, animated: false)
        cell.editButton.tag = indexPath.row
        
        // Set the delegate to this Main View Controller
        cell.cellDelegate = self
        return cell;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let segueToEdit = segue.destination as? EditViewController {

            if let identifier = segue.identifier {
                
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
    
    // MARK: Delegate Protocol of EditViewControllers
    func saveItem(controller: EditViewController, _ task: Task) {
        tasks[taskIndex!] = task
        updateTaskInDB(task: tasks[taskIndex!])
        print("\(tasks[taskIndex!].name) ")
    }
    
    func deleteItem(controller: EditViewController, _ task: Task) {
        deleteTaskFromDB(index: task.id!)
        tasks.remove(at: taskIndex!)
    }
    
    // MARK: Delegate Protocol of EditViewControllers
    func didChangeSwitchState(sender: TaskTableViewCell, isOn: Bool) {
        if let indexPath = self.table.indexPath(for: sender) {
            tasks[indexPath.row].onGoing = isOn
            updateTaskLabels(sender, indexPath.row)
            // Update the task in the database
            updateTaskInDB(task: tasks[indexPath.row])
        }
    }
    
    // Update the task name and notes labels
    private func updateTaskLabels(_ cell: TaskTableViewCell, _ row: Int) {
        
        // Set the color to light gray if the UISwitch is disabled
        cell.editButton.setTitleColor(UIColor.lightGray, for: .disabled)

        // Customize the task name and notes text appearance based on its status
        if tasks[row].onGoing {
            cell.taskLabel.text = tasks[row].name
            cell.subTaskLabel.text = tasks[row].notes
            cell.editButton.isEnabled = true
        } else {
            let nameAttributeString = NSMutableAttributedString(string:tasks[row].name)
            nameAttributeString.addAttribute(NSStrikethroughStyleAttributeName,
                                         value: 2,
                                         range: NSMakeRange(0, nameAttributeString.length))
            cell.taskLabel.attributedText = nameAttributeString
            cell.subTaskLabel.text = ""
            cell.editButton.isEnabled = false
        }
    }

    // MARK: SQLite Handlers
    func dataFilePath() -> String {
        let urls = FileManager.default.urls(for:
            .documentDirectory, in: .userDomainMask)
        var url:String?
        url = urls.first?.appendingPathComponent("taskdata.plist").path
        return url!
    }
    
    // Read tasks from the database
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
                    let rowOngoing = Int(sqlite3_column_int(statement, 3))
                    let fieldValue = String.init(cString: rowData!)
                    let fieldNoteValue = String.init(cString: rowNote!)
                    let onGoingValue = rowOngoing == 1 ? true : false
                    tasks.append(Task(name: fieldValue,
                                      id:row,
                                      fieldNoteValue,
                                      onGoingValue))
                    
                    print("Read: \(row), \(fieldValue), \(fieldNoteValue)")
                }
                
                sqlite3_finalize(statement)
            }
        }
        
        sqlite3_close(database)
    }
    
    // Insert task to the database
    func insertTaskToDB(task: Task) -> Int? {
        var id: Int?
        
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        
        if result !=  SQLITE_OK {
            print("Failed to open database")
        } else {
            var statement:OpaquePointer? = nil
            // Note: When inserting rows to the table, there is no need to specify the task ID
            //          since the ID is setup to AUTOINCREMENT when the Task table was created.
            //          This is the reason why the ID is not included here
            let update = "INSERT INTO FIELDS (TASK_DATA, TASK_NOTE, ONGOING) VALUES (?, ?, ?);"
            
            if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
                let taskName = task.name as NSString
                let taskNote = task.notes as NSString
                let onGoing = task.onGoing ? 1 : 0
                
                sqlite3_bind_text(statement, 1, taskName.utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, taskNote.utf8String, -1, nil)
                sqlite3_bind_int(statement, 3, Int32(onGoing))
                
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
            var statement:OpaquePointer? = nil
            let update = "INSERT OR REPLACE INTO FIELDS (ID, TASK_DATA, TASK_NOTE, ONGOING) VALUES (?, ?, ?, ?);"
            
            if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
                let taskName = task.name as NSString
                let taskNote = task.notes as NSString
                let onGoing = task.onGoing ? 1 : 0
  
                sqlite3_bind_int(statement, 1, Int32(task.id!))
                sqlite3_bind_text(statement, 2, taskName.utf8String, -1, nil)
                sqlite3_bind_text(statement, 3, taskNote.utf8String, -1, nil)
                sqlite3_bind_int(statement, 4, Int32(onGoing))
            }
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error updating table")
            } else {
                print("Updated \(task.id!)")
                sqlite3_finalize(statement)
            }
        }
        
        sqlite3_close(database)
    }
}

