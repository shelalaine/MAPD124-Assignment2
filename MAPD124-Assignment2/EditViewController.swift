//
//  EditViewController.swift
//  MAPD124-Assignment2
//
//  Created by Shelalaine Chan on 2017-02-07.
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import UIKit


class EditViewController: UIViewController {
    
    private var titles: Dictionary<String, String> = [
        "EditSegue": "Edit Task",
        "AddSegue": "Add Task"
    ]
    
    @IBOutlet weak var taskNameTextField: UITextField!
    
    
    var task: String?
    var titleLabel: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.title = titles[titleLabel!]
        taskNameTextField.text = task
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
