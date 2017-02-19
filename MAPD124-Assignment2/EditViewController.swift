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
    
}
