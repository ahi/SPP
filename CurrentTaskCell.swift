//
//  CurrentTaskCell.swift
//  WeekPlaner
//
//  Created by Seydi Ahmet Kiyak on 29.06.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//

import UIKit

class CurrentTaskCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    @IBAction func switchTapped(sender: UISwitch) {
        if let d = delegate {
            d.taskSwitchChanged(sender.on, task: task!)
        }
    }
    
    var delegate: TaskActionProtocol?
    
    var task: Task? {
        didSet {
            if let t = task {
                taskName.text = t.name
                duration.text = t.duration().description
            }
        }
    }
}


protocol TaskActionProtocol {
    func taskSwitchChanged(active: Bool, task: Task)
}