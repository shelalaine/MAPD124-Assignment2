//
//  TodoTableViewCell.swift
//  MAPD124-Assignment2
//
//  Created by Shelalaine Chan on 2017-01-31.
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
