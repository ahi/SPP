//
//  CurrentWeekTableVC.swift
//  WeekPlaner
//
//  Created by Seydi Ahmet Kiyak on 29.06.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//

import UIKit
import CoreData

class CurrentWeekTableVC: UITableViewController, NSFetchedResultsControllerDelegate, TaskActionProtocol {
    
    
    let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    let currentDate = NSDate()
    
    let noTaskCellId = "noTaskCell"
    let taskCellId = "taskCell"
    
    var currentWeekNr: WeekNr? {
        didSet {
            let dayOfWeek = self.gregorian.component(.Weekday, fromDate: self.currentDate)
            let dayOfWeekcurrentLocation = (dayOfWeek + 7 - NSCalendar.currentCalendar().firstWeekday) % 7 + 1
            weekProgress.progress = Float(dayOfWeekcurrentLocation) / 7.0
            if let taskDuration = currentWeekNr?.weekType?.tasksDuration().float where taskDuration > 0.0 {
                taskProgress.progress = Float(currentWeekNr!.finished!) / taskDuration
            }
        }
    }
    
    @IBOutlet weak var weekProgress: UIProgressView!
    @IBOutlet weak var taskProgress: UIProgressView!
    
    lazy var currentWeekFetchRequest: NSFetchRequest = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "WeekNr")
        
        
        let currentWeek = self.gregorian.component(.WeekOfYear, fromDate: self.currentDate)
        let currentYear = self.gregorian.component(.Year, fromDate: self.currentDate)
        
        let weekPredicate = NSPredicate(format: "week = %i", currentWeek)
        let yearPredicate = NSPredicate(format: "year = %i", currentYear)
        
        let andPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [weekPredicate, yearPredicate])
        fetchRequest.predicate = andPredicate
        
        
        let weekSortDescriptor = NSSortDescriptor(key: "week", ascending: true)
        fetchRequest.sortDescriptors = [weekSortDescriptor]
        
        
        return fetchRequest
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: self.currentWeekFetchRequest, managedObjectContext: self.managedObjectContext(), sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = 80.0
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        do {
            try managedObjectContext().save()
        } catch {
            print(error)
        }
    }
    
    func configure() {
        self.gregorian.minimumDaysInFirstWeek = 4
    }
    
    override func viewWillAppear(animated: Bool) {
        if fetchedResultsController.fetchedObjects?.count > 0, let weekNr = fetchedResultsController.fetchedObjects?[0] as? WeekNr {
            currentWeekNr = weekNr
            self.navigationItem.title = "Woche \(weekNr.week!.intValue)"
        }
        self.tableView.reloadData()
    }
    
    // MARK: - TaskActionProtokol
    func taskSwitchChanged(active: Bool, task: Task) {
        if let week = currentWeekNr {
            var currentFinished: Float
            if let f = week.finished {
                currentFinished = Float(f)
            }
            else {
                currentFinished = 0.0
            }
            
            if active {
                currentFinished = currentFinished + task.duration().float
            }
            else {
                currentFinished = currentFinished - task.duration().float
            }
            week.finished = NSNumber(float: currentFinished)
            
            
            taskProgress.progress = currentFinished / week.weekType!.tasksDuration().float
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tasks = currentWeekNr?.weekType?.tasks {
            return tasks.count
        }
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let tasks = currentWeekNr?.weekType?.tasks where tasks.count > 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(taskCellId, forIndexPath: indexPath) as! CurrentTaskCell
            let task = tasks.allObjects[indexPath.row] as! Task
            cell.task = task
            cell.delegate = self
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(noTaskCellId, forIndexPath: indexPath)
            return cell
        }

    }
}
