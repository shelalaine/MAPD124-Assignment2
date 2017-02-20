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
    
    let NOTES_PLACEHOLDER_TEXTVIEW = "Enter note / description of the task"
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
        
//        let app = UIApplication.shared
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.applicationWillResignActive(notification:)),
//                                               name: Notification.Name.UIApplicationWillResignActive,
//                                               object: app)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.title = titles[titleLabel!]
        
        // Add border to UITextView
        let borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        self.taskNoteTextView.layer.borderWidth = 0.5
        self.taskNoteTextView.layer.borderColor = borderColor.cgColor
        self.taskNoteTextView.layer.cornerRadius = 5.0
        
        taskNameTextField.text = task?.name
        
        // Set the task note or the placeholder if notes is empty
        if task?.notes != "" {
            taskNoteTextView.text = task?.notes
            taskNoteTextView.textColor = UIColor.black
        } else {
            taskNoteTextView.textColor = UIColor.lightGray
            taskNoteTextView.text = NOTES_PLACEHOLDER_TEXTVIEW
        }
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
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    
        if textView == taskNoteTextView  && textView.text == NOTES_PLACEHOLDER_TEXTVIEW {
            textView.selectedRange = NSMakeRange(0, 0)
        }
        return true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let taskNote = textView.text {
            task?.notes = taskNote
        }
        taskNoteTextView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        print("textView count: \(textView.text.utf16.count) Text count: \(text.utf16.count) Range length: \(range.length)")
        if newLength > 0 {
            // Check if Notes placeholder is shown
            if textView == taskNoteTextView  && textView.text == NOTES_PLACEHOLDER_TEXTVIEW {

                taskNoteTextView.text = ""
                taskNoteTextView.textColor = UIColor.black
            }
        } else {
            taskNoteTextView.textColor = UIColor.lightGray
            taskNoteTextView.text = NOTES_PLACEHOLDER_TEXTVIEW
            
            // Move cursor to start
            textView.selectedRange = NSMakeRange(0, 0)
        }
        print("New length: \(newLength)")
        return true
    }
    
    
    // MARK: Button Actions
    @IBAction func deleteButtonHandler(_ sender: UIButton) {
    }
    
    @IBAction func cancelButtonHandler(_ sender: UIButton) {
    }
    
    @IBAction func updateButtonHandler(_ sender: UIButton) {
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
