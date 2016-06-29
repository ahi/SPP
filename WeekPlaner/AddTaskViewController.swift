//
//  AddTaskViewController.swift
//  WeekPlaner
//
//  Created by Seydi Ahmet Kiyak on 08.06.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, TaskEntityCreatorDelegate {
    
    private let taskViewModel = TaskViewModel()

    @IBOutlet weak var nameTextfield: UITextField! {
        didSet {
            nameTextfield.addTarget(
                self,
                action: #selector(AddTaskViewController.nameChanged(_:)),
                forControlEvents: UIControlEvents.EditingChanged)
        }
    }
    
    @IBOutlet weak var timePicker: UIPickerView!

    var context: NSManagedObjectContext!
    
    private enum PickerRows: Int {
        case Hour, Minute
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.dataSource = self
        timePicker.delegate = self
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appDelegate.managedObjectContext
        
        taskViewModel.taskEntityCreatorDelegate = self
    }
    
    @IBAction func save(sender: AnyObject) {
        
        do {
            try taskViewModel.createTask().managedObjectContext?.save()
            navigationController?.popViewControllerAnimated(true)
        } catch TaskViewModelError.EmptyNameGiven {
            showAlert("Eingabefehler", message: "Ein Task braucht einen Namen.")
            return
        } catch TaskViewModelError.NoTimeGiven {
            showAlert("Eingabefehler", message: "Ein Task muss eine gewisse Dauer haben.")
            return
        } catch {
            print("Error in CreateTask")
            print(error)
            return
        }
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 40
        } else {
            return 4
        }
    }
    
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 180
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return "\(row) Stunden"
        } else {
            return "\(taskViewModel.selectableMinutes[row]) Minuten"
        }
    }
    
    // MARK: ViewModel updates
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let pickerRow = PickerRows(rawValue: component) {
            switch pickerRow {
            case .Hour:
                taskViewModel.hours = row
            case .Minute:
                taskViewModel.minutes = row
            }
        }
    }
    
    func nameChanged(textField: UITextField) {
        taskViewModel.taskName = textField.text
    }

    // MARK: TaskEntityCreatorDelegate
    
    func createTaskEntity() -> Task {
        let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: context)
        return Task(entity: entity!, insertIntoManagedObjectContext: context)
    }
}
