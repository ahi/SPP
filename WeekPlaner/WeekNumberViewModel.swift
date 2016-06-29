//
//  WeekNumberViewModel.swift
//  WeekPlaner
//
//  Created by Seydi Ahmet Kiyak on 25.06.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//

import Foundation
import CoreData

class WeekNumberViewModel {
    
    let minimumNumberOfWeeks = 14
    
    var fetchedResultsController: NSFetchedResultsController?
    var delegate: WeekNumberViewModelDelegate?
    
    func loadData() throws {
        guard let fetchedResultsController = fetchedResultsController else {
            throw WeekNumberViewModelError.NoResultControllerGiven
        }
        
        try fetchedResultsController.performFetch()
        if let count = fetchedResultsController.fetchedObjects?.count where
            count < minimumNumberOfWeeks {
            try createWeeks(minimumNumberOfWeeks - count, startThisWeek: count == 0)
            try fetchedResultsController.performFetch()
        }
    }
    
    private func createWeeks(amountOfWeeks: Int, startThisWeek: Bool) throws {
        guard let delegate = delegate else {
            throw WeekNumberViewModelError.NoWeekNumberEntityCreatorDelegateGiven
        }
        
        var missingWeek: NSDate
        
        do {
            if (startThisWeek) {
                missingWeek = NSDate()
            } else {
                missingWeek = try getFirstMissingWeek()
            }
        } catch {
            print(error)
            return
        }
        
        
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        // Erste woche muss Donnerstag beinhalten, ISO 8601
        gregorian?.minimumDaysInFirstWeek = 4
        let dayComponent = NSDateComponents()
        dayComponent.day = 7
        
        for _ in 1...amountOfWeeks {
            let weekNr = delegate.createWeekNumberEntity()
            weekNr.week = gregorian!.component(NSCalendarUnit.WeekOfYear, fromDate: missingWeek)
            weekNr.year = gregorian!.component(NSCalendarUnit.Year, fromDate: missingWeek)
            try weekNr.managedObjectContext?.save()
            missingWeek = gregorian!.dateByAddingUnit(.Day, value: 7, toDate: missingWeek, options: NSCalendarOptions(rawValue: 0))!
        }
    }
    
    private func getFirstMissingWeek() throws -> NSDate {
        guard let fetchedResultsController = fetchedResultsController else {
            throw WeekNumberViewModelError.NoResultControllerGiven
        }
        
        
        
        let fetchRequest = NSFetchRequest(entityName: "WeekNr")
        
        // Add Sort Descriptors
        let yearSortDescriptor = NSSortDescriptor(key: "year", ascending: false)
        let weekNrSortDescripor = NSSortDescriptor(key: "week", ascending: false)
        fetchRequest.sortDescriptors = [yearSortDescriptor, weekNrSortDescripor]
        fetchRequest.fetchLimit = 1
        
        
        
        try fetchedResultsController.performFetch()
        if let objects = fetchedResultsController.fetchedObjects {
            let weekNr = objects[0] as! WeekNr
            
            let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            gregorian?.minimumDaysInFirstWeek = 4
            let dateComponent = NSDateComponents()
            dateComponent.weekOfYear = Int(weekNr.week!)
            dateComponent.year = Int(weekNr.year!)
            
            let lastStoredWeek = gregorian!.dateFromComponents(dateComponent)
            
            let missingWeek = lastStoredWeek?.dateByAddingTimeInterval(-60 * 60 * 24 * 7)
            return missingWeek!
            
        }
        else {
            // no Weeks in Database create this week as missing week
            let date = NSDate()
            return date
        }
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        if let frc = fetchedResultsController,
            let sections = frc.sections {
            return sections[section].numberOfObjects
        }
        
        return 0
    }
    
    func numberOfSections() -> Int {
        if let frc = fetchedResultsController,
            let sections = frc.sections {
            return sections.count
        }
        
        return 0
    }
    
    func entity(atIndexPath indexPath: NSIndexPath) throws -> WeekNr {
        guard let fetchedResultsController = fetchedResultsController else {
            throw WeekNumberViewModelError.NoResultControllerGiven
        }
        
        return fetchedResultsController.objectAtIndexPath(indexPath) as! WeekNr
    }
    
    func entity(atIndex index: Int) throws -> WeekNr {
        guard let fetchedResultsController = fetchedResultsController else {
            throw WeekNumberViewModelError.NoResultControllerGiven
        }
        
        let entities = fetchedResultsController.fetchedObjects as! [WeekNr]
        
        return entities[index]
    }

}

/**
 Error type that can be thrown from WeekNumberViewModel
 
 - NoResultControllerGiven: fetchedResultsController is not set, set it before you use any function
 - WeekNumberEntityCreatorDelegate: createWeekNumberEntityDelegate is not set, set it before you use any function
 */
enum WeekNumberViewModelError: ErrorType {
    case NoResultControllerGiven
    case NoWeekNumberEntityCreatorDelegateGiven
}

protocol WeekNumberViewModelDelegate {
    func createWeekNumberEntity() -> WeekNr
}
