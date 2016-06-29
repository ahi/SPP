//
//  TaskViewModel.swift
//  WeekPlaner
//
//  Created by Seydi Ahmet Kiyak on 24.06.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//

import Foundation

class TaskViewModel {
    var taskName: String?
    var hours = 0
    var minutes = 0
    
    let selectableMinutes = [0, 15, 30, 45]
    
    var taskEntityCreatorDelegate: TaskEntityCreatorDelegate?
    
    func createTask() throws -> Task {
        switch (taskName) {
        case let (.Some(taskName)):
            
            guard !taskName.isEmpty else {
                throw TaskViewModelError.EmptyNameGiven
            }
            print("Zeit \(hours) \(minutes)")
            guard (hours + minutes) > 0 else {
                throw TaskViewModelError.NoTimeGiven
            }
            
            guard let delegate = taskEntityCreatorDelegate else {
                throw TaskViewModelError.NoDelegateGiven
            }
            
            let t = delegate.createTaskEntity()
            t.name = taskName
            t.hours = hours
            t.minutes = selectableMinutes[minutes]
            t.splitable = false
            
            return t
            
        default:
            throw TaskViewModelError.EmptyNameGiven
        }
    }
}

protocol TaskEntityCreatorDelegate {
    func createTaskEntity() -> Task
}



/**
 Error type that can be thrown from createTask
 
 - EmptyNameGiven: taskName is nil or Empty
 - NoTimeGiven: hour or minute is nil or hour + minute = 0
 - NoDelegateGiven: You have to set a TaskEntityCreatorDelegate that creates a Task with a entity and ManagedObjectContext in which it is added
 */
enum TaskViewModelError: ErrorType {
    case EmptyNameGiven
    case NoTimeGiven
    case NoDelegateGiven
}
/*
 
 if name == nil || (name?.isEmpty)! {
 showAlert("Eingabefehler", message: "Ein Task braucht einen Namen.")
 return
 }
 
 if (hours + selectedMinute) <= 0 {
 showAlert("Eingabefehler", message: "Ein Task muss eine gewisse Dauer haben.")
 return
 }
 
 */