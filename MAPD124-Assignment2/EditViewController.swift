//
//  EditViewController.swift
//  MAPD124-Assignment2
//
//  Created by Shelalaine Chan on 2017-02-07.
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import UIKit

protocol EditViewControllerDelegate  {
    func saveItem(controller: EditViewController, _ task: Task)
}


class EditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    private var titles: Dictionary<String, String> = [
        "EditSegue": "Edit Task",
        "AddSegue": "Add Task"
    ]
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskNoteTextView: UITextView!
    
    
    var task: Task?
    var titleLabel: String?
    var delegate: EditViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskNameTextField.delegate = self
        self.taskNoteTextView.delegate = self
        taskNameTextField.becomeFirstResponder()
        
        // Add border to UITextView
        let borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        self.taskNoteTextView.layer.borderWidth = 0.5
        self.taskNoteTextView.layer.borderColor = borderColor.cgColor
        self.taskNoteTextView.layer.cornerRadius = 5.0
        
        
        
//        let app = UIApplication.shared
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.applicationWillResignActive(notification:)),
//                                               name: Notification.Name.UIApplicationWillResignActive,
//                                               object: app)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.title = titles[titleLabel!]
        taskNameTextField.text = task?.name
        taskNoteTextView.text = task?.notes
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.saveItem(controller: self, task!)
    }
    
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskNameTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let taskName = textField.text {
            task?.name = taskName
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let taskNote = textView.text {
            task?.notes = taskNote
        }
        taskNoteTextView.resignFirstResponder()
    }
    
//    func applicationWillResignActive(notification: NSNotification) {
//        var database:OpaquePointer? = nil
//        let result = sqlite3_open(dataFilePath(), &database)
//        
//        if result !=  SQLITE_OK {
//            print("Failed to open database")
//        } else {
//            let update = "INSERT INTO FIELDS (TASK_DATA, TASK_NOTE) VALUES (?, ?);"
//            var statement:OpaquePointer? = nil
//            
//            for index in 0..<tasks.count {
//                if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
//                    
//                    let taskName = tasks[index].name as NSString
//                    let taskNote = tasks[index].notes as NSString
//                    
//                    sqlite3_bind_text(statement, 1, taskName.utf8String, -1, nil)
//                    sqlite3_bind_text(statement, 2, taskNote.utf8String, -1, nil)
//                    
//                    print("Written: \(index), \(tasks[index].name), \(tasks[index].notes)")
//                }
//                
//                if sqlite3_step(statement) != SQLITE_DONE {
//                    print("Error updating table")
//                } else {
//                    sqlite3_finalize(statement)
//                }
//            }
//        }
//        sqlite3_close(database)
//    }
    
}
