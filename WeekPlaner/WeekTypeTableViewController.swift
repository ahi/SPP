//
//  WeekTypeTableViewController.swift
//  WeekPlaner
//
//  Created by Seydi Ahmet Kiyak on 07.06.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//

import UIKit
import CoreData

class WeekTypeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var weekNr: WeekNr? {
        didSet {
            if weekNr != nil {
        
                // No need for add button, if we want only select a weekType for WeekNr
                addButton = self.navigationItem.rightBarButtonItem
                self.navigationItem.rightBarButtonItem = nil
                self.navigationItem.title = selectorTitle
            }
            else {
                self.navigationItem.rightBarButtonItem = addButton
                self.navigationController?.title = defaultTitle
            }
        }
    }
    
    var isMainView: Bool {
        get {
            return weekNr == nil
        }
    }
    
    let cellName = "WeekTypeCell"
    let taskSegueId = "TaskSegue"
    let addSegueId = "AddWeekTyp"
    
    let defaultTitle = "Wochentyp"
    let selectorTitle = "Wochentyp auswählen"
    var addButton: UIBarButtonItem?
    
    var context: NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "WeekType")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext(), sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellName, forIndexPath: indexPath) as! WeekTypeTableViewCell

        let weekType = fetchedResultsController.objectAtIndexPath(indexPath) as! WeekType
        
        cell.weekType = weekType

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let weekNr = weekNr {
            let weekType = fetchedResultsController.objectAtIndexPath(indexPath) as! WeekType
            weekNr.weekType = weekType
            weekNr.finished = 0.0
            do {
                try weekNr.managedObjectContext?.save()
            } catch {
                self.showAlert("Fehler", message: "Fehler beim Speichern")
                print(error)
            }
            self.weekNr = nil
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == taskSegueId) {
            let taskVC =  segue.destinationViewController as! TaskTableViewController
            guard let index = tableView.indexPathForSelectedRow?.row else {
                return
            }
            
            print("sender")
            print(sender)
            let weekTypes = fetchedResultsController.fetchedObjects as! [WeekType]
            taskVC.weekType = weekTypes[index]
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if isMainView {
            return true
        }
        return false
    }
}
