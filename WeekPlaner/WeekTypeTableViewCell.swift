//
//  WeekTypeTableViewCell.swift
//  WeekPlaner
//
//  Created by Seydi Ahmet Kiyak on 08.06.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//

import UIKit

class WeekTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var weekTypeName: UILabel!
    @IBOutlet weak var weekTypeTime: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    var weekType: WeekType? {
        didSet {
            if let wt = weekType {
                weekTypeName.text = wt.name
                weekTypeTime.text = "\(wt.tasksDuration()) / \(wt.duration())"
                progressBar.progress = wt.progress
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
