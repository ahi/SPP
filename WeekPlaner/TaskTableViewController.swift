//
//  TaskTableViewController.swift
//  WeekPlaner
//
//  Created by Seydi Ahmet Kiyak on 08.06.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//

import UIKit
import CoreData

class TaskTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let cellName = "TaskCell"
    
    var defaultTitle: String?
    
    var context: NSManagedObjectContext!
    
    var weekType: WeekType? {
        didSet {
            if let weekType = weekType {
                isMainView = false
                self.tableView.allowsMultipleSelection = true
                self.tableView.allowsSelection = true
                
                addButton = self.navigationItem.rightBarButtonItem
                self.navigationItem.rightBarButtonItem = nil
                
                defaultTitle = self.navigationItem.title
                self.navigationItem.title = weekType.name
            }
            else {
                isMainView = true
                self.tableView.allowsMultipleSelection = false
                self.tableView.allowsSelection = false
                self.navigationController?.title = defaultTitle
            }
        }
    }
    
    var isMainView = true
    var addButton: UIBarButtonItem?
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Task")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initial setup
        self.tableView.allowsMultipleSelection = false
        self.tableView.allowsSelection = false
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appDelegate.managedObjectContext
        
        loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        self.tableView.reloadData()
    }
    
    func loadData() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        }
        
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellName, forIndexPath: indexPath) as! TaskTableViewCell
        
        let task = fetchedResultsController.objectAtIndexPath(indexPath) as! Task
        
        if let name = task.name {
            cell.taskName.text = name
        }
        
        cell.taskTime.text = task.duration().description
        
        if let weekType = weekType, let tasks = weekType.tasks where tasks.containsObject(task) {
            self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            //cell.setSelected(tasks.containsObject(task), animated: false)
        }
        
        return cell
    }

    /**
     * Add Task
     */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let weekType = weekType {
            let task = fetchedResultsController.objectAtIndexPath(indexPath) as! Task
            
            
            var remainingDuration = weekType.duration() - weekType.tasksDuration()
            remainingDuration = remainingDuration - task.duration()
            
            print("WeekType duration: \(weekType.duration().description)")
            print("WeekType tasks duration: \(weekType.tasksDuration().description)")
            print("Task duration: \(task.duration().description)")
            print("Remaining duration: \(remainingDuration.description)")
            
            
            if remainingDuration.isNegativ() {
                self.showAlert("Zu wenig Zeit", message: "Keine Zeit mehr für diese Aufgabe in dieser Woche")
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            else {
                weekType.addTask(task)
                
                do {
                    try weekType.managedObjectContext?.save()
                } catch {
                    self.showAlert("Fehler", message: "Fehler beim Speichern")
                    print(error)
                }
            }
        }
    }
    
    /**
     * Remove Task
     */
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let weekType = weekType {
            let task = fetchedResultsController.objectAtIndexPath(indexPath) as! Task
            weekType.removeTask(task)
            do {
                try weekType.managedObjectContext?.save()
            } catch {
                self.showAlert("Fehler", message: "Fehler beim Speichern")
                print(error)
            }
        }
    }
}
