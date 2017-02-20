//
//  TodoTableViewCell.swift
//  MAPD124-Assignment2
//
//  Created by Shelalaine Chan on 2017-01-31.
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

        // Configure the view for the selected state
    }
    
    @IBAction func taskSwitchHandler(_ sender: UISwitch) {
        self.cellDelegate?.didChangeSwitchState(sender: self, isOn: completedSwitch.isOn)
    }

}
