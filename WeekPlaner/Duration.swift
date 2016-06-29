//
//  Duration.swift
//  WeekPlaner
//
//  Created by Seydi Ahmet Kiyak on 29.06.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//

import Foundation

struct Duration: CustomStringConvertible {
    let hours: Int
    let minutes: Int
    
    var float: Float {
        if self.minutes > 0 {
            return Float(self.hours) + (1.0 / 60.0) * Float(minutes)
        }
        else {
            return Float(self.hours)
        }
    }
    
    var description: String {
        
        let formatedMinute = String(format: "%02d", minutes)
        return "\(hours)h \(formatedMinute)m"
    }
    
    init(hours: Int, minutes: Int) {
        self.hours = hours
        self.minutes = minutes
    }
    
    func isNegativ() -> Bool {
        return hours < 0
    }
}


func -(left: Duration, right: AnyObject) -> Duration {
    let r = right as! Duration
    return left - r
}

func -(left: Duration, right: Duration) -> Duration {
    var hours = left.hours
    var minutes = left.minutes
    if left.minutes < right.minutes {
        hours = hours - 1
        minutes = minutes + 60
    }
    
    minutes = minutes - right.minutes
    hours = hours - right.hours
    return Duration(hours: hours , minutes: minutes)
}

func +(left: Duration, right: AnyObject) -> Duration {
    let r = right as! Duration
    return left - r
}

func +(left: Duration, right: Duration) -> Duration {
    var hours = left.hours + right.hours
    var minutes = left.minutes + right.minutes
    
    if minutes >= 60 {
        minutes = minutes - 60
        hours = hours + 1
    }
    
    return Duration(hours: hours , minutes: minutes)
}