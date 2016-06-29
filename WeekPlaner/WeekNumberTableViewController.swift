//
//  WeekNumberTableViewController.swift
//  WeekPlaner
//
//  Created by Ahmet Kiyak on 21.06.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//

import UIKit
import CoreData

class WeekNumberTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, WeekNumberViewModelDelegate {
    
    let cellId = "weekNumberCell"
    let segueId = "weekTypeSegue"
    
    var firstTime = true
    
    let weekNumberViewModel = WeekNumberViewModel()
    
    lazy var selectAllfetchRequest: NSFetchRequest = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "WeekNr")
        
        // Add Sort Descriptors
        let yearSortDescriptor = NSSortDescriptor(key: "year", ascending: true)
        let weekNrSortDescripor = NSSortDescriptor(key: "week", ascending: true)
        fetchRequest.sortDescriptors = [yearSortDescriptor, weekNrSortDescripor]
        
        return fetchRequest
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: self.selectAllfetchRequest, managedObjectContext: self.managedObjectContext(), sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weekNumberViewModel.fetchedResultsController = self.fetchedResultsController
        weekNumberViewModel.delegate = self
        
        do {
            try weekNumberViewModel.loadData()
        } catch {
            print(error)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // Dont double load
        if (!firstTime) {
            self.tableView.reloadData()
        } else {
            firstTime = false
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return weekNumberViewModel.numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekNumberViewModel.numberOfRows(inSection: section)
    }
    
    // Mark: WeekNumberEntityCreatorDelegate
    
    func createWeekNumberEntity() -> WeekNr {
        let entity = NSEntityDescription.entityForName("WeekNr", inManagedObjectContext: self.managedObjectContext())
        return WeekNr(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext())
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! WeekNumberCell

        do {
            let weekEntity = try weekNumberViewModel.entity(atIndexPath: indexPath)
            cell.weekNumberLabel.text = "\(weekEntity.week!) / \(weekEntity.year!)"
            
            if let weekType = weekEntity.weekType {
                cell.weekTypLabel.text = weekType.name
            }
        } catch {
            print(error)
        }

        return cell
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == segueId) {
            let weekTypeVC =  segue.destinationViewController as! WeekTypeTableViewController
            guard let index = tableView.indexPathForSelectedRow?.row else {
                return
            }
            print("sender")
            print(sender)
            do {
                weekTypeVC.weekNr = try weekNumberViewModel.entity(atIndex: index)
            } catch {
                print(error)
            }
        }
    }

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
}
