//
//  File Name:      EditViewController.swift
//  Project Name:   MAPD124-Assignment2
//  Description:    This is the detailed UI View Controller of the selected task
//
//  Created by:     Shelalaine Chan
//  Student ID:     300924281
//  Change History: 2017-02-07, Created
//                  2017-02-21, Added Update, Cancel, and Delete Action button handlers
//                              Enhanced the Notes TextView appearance
//
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import UIKit

protocol EditViewControllerDelegate  {
    func saveItem(controller: EditViewController, _ task: Task)
    func deleteItem(controller: EditViewController, _ task: Task)
}


class EditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    let NOTES_PLACEHOLDER_TEXTVIEW = "Enter note / description of the task"
    let TASK_PLACEHOLDER_TEXTVIEW = "Enter task name"
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskNoteTextView: UITextView!
    
    var task: Task?
    var delegate: EditViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskNameTextField.delegate = self
        self.taskNoteTextView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {

        // Show the task name
        taskNameTextField.placeholder = TASK_PLACEHOLDER_TEXTVIEW
        if task?.name != "" {
            taskNameTextField.text = task?.name
        }
        
        // Set the task note or the placeholder if notes is empty
        if task?.notes != "" {
            taskNoteTextView.text = task?.notes
            taskNoteTextView.textColor = UIColor.black
        } else {
            taskNoteTextView.textColor = UIColor.lightGray
            taskNoteTextView.text = NOTES_PLACEHOLDER_TEXTVIEW
        }

        // Add border to UITextView
        let borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        self.taskNoteTextView.layer.borderWidth = 0.5
        self.taskNoteTextView.layer.borderColor = borderColor.cgColor
        self.taskNoteTextView.layer.cornerRadius = 5.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        taskNameTextField.resignFirstResponder()
        taskNoteTextView.resignFirstResponder()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    
        if textView == taskNoteTextView  && textView.text == NOTES_PLACEHOLDER_TEXTVIEW {
            textView.selectedRange = NSMakeRange(0, 0)
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
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
        return true
    }
    
    
    // MARK: Button Actions
    @IBAction func deleteButtonHandler(_ sender: UIButton) {
        delegate?.deleteItem(controller: self, task!)
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonHandler(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateButtonHandler(_ sender: UIButton) {
        task?.name = taskNameTextField.text!
        task?.notes = taskNoteTextView.text
        delegate?.saveItem(controller: self, task!)
        
        _ = navigationController?.popViewController(animated: true)
    } 
}
