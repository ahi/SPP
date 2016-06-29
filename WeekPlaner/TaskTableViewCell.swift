//
//  TaskTableViewCell.swift
//  WeekPlaner
//
//  Created by Seydi Ahmet Kiyak on 08.06.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
