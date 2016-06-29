//
//  WeekType.swift
//  WeekPlaner
//
//  Created by Seydi Ahmet Kiyak on 08.06.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//

import Foundation
import CoreData


class WeekType: NSManagedObject {
    
    var progress: Float {
        return (100.0 / duration().float) * tasksDuration().float / 100.0
    }

    func addTask(task: Task) {
        let tasks = self.mutableSetValueForKey("tasks")
        tasks.addObject(task)
    }
    
    func removeTask(task: Task) {
        let tasks = self.mutableSetValueForKey("tasks")
        tasks.removeObject(task)
    }
    
    func hasTask(task: Task) -> Bool {
        let tasks = self.valueForKey("tasks") as! NSMutableSet
        return tasks.containsObject(task)
    }
    
    func duration() -> Duration {
        return Duration(hours: self.hours!.integerValue, minutes: self.minutes!.integerValue)
    }
    
    func tasksDuration() -> Duration {
        let tasks = self.valueForKey("tasks") as! NSSet
        
        let durations = tasks.map { ($0 as! Task).duration() }
        return durations.reduce(Duration(hours: 0, minutes: 0), combine: +)
    }
    
}
