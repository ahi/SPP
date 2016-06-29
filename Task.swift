//
//  Task.swift
//  WeekPlaner
//
//  Created by Seydi Ahmet Kiyak on 08.06.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//

import Foundation
import CoreData


class Task: NSManagedObject {

    func duration() -> Duration {
        return Duration(hours: self.hours!.integerValue, minutes: self.minutes!.integerValue)
    }
}
