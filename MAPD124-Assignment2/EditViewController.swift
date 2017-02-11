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


class EditViewController: UIViewController, UITextFieldDelegate {
    
    private var titles: Dictionary<String, String> = [
        "EditSegue": "Edit Task",
        "AddSegue": "Add Task"
    ]
    
    @IBOutlet weak var taskNameTextField: UITextField!
    
    
    var task: Task?
    var titleLabel: String?
    var delegate: EditViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskNameTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        self.title = titles[titleLabel!]
        taskNameTextField.text = task?.name
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("Should begin editing")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let taskName = textField.text {
            task?.name = taskName
            delegate?.saveItem(controller: self, task!)
        }
        taskNameTextField.resignFirstResponder()
        return true
    }
    
}
