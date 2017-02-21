//
//  File Name:      TodoTableViewCell.swift
//  Project Name:   MAPD124-Assignment2
//  Description:    This is the custom UI Table View Cell of the task table
//
//  Created by:     Shelalaine Chan
//  Student ID:     300924281
//  Change History: 2017-01-31, Created
//                  2017-02-20, Added taskSwitchHandler for the UI Switch button
//
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import UIKit

protocol SettingCellDelegate: class {
    func didChangeSwitchState(sender: TaskTableViewCell, isOn: Bool)
}

class TaskTableViewCell: UITableViewCell {
    
    var cellDelegate: SettingCellDelegate?
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var subTaskLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var completedSwitch: UISwitch!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func taskSwitchHandler(_ sender: UISwitch) {
        self.cellDelegate?.didChangeSwitchState(sender: self, isOn: completedSwitch.isOn)
    }

}
