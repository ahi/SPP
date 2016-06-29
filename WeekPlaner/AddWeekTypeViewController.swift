//
//  AddWeekTypViewController.swift
//  WeekPlaner
//
//  Created by Seydi Ahmet Kiyak on 07.06.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//

import UIKit
import CoreData

class AddWeekTypeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var timePicker: UIPickerView!
    
    var context: NSManagedObjectContext!
    
    let minutes = [0, 15, 30, 45]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.dataSource = self
        timePicker.delegate = self
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appDelegate.managedObjectContext
        
        if traitCollection.horizontalSizeClass == .Compact {
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(AddWeekTypeViewController.cancel))
            self.navigationItem.leftBarButtonItem = cancelButton
        }
    }
    
    func cancel() {
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func save(sender: AnyObject) {
        let hours = timePicker.selectedRowInComponent(0)
        let selectedMinute = minutes[timePicker.selectedRowInComponent(1)]
        let name = nameTextfield.text
        
        if name == nil || (name?.isEmpty)! {
            showAlert("Eingabefehler", message: "Ein Wochentyp braucht einen Namen")
            return
        }
        
        if (hours + selectedMinute) <= 0 {
            showAlert("Eingabefehler", message: "Einem Wochentypen muss Zeit zur verfügung gestellt werden")
            return
        }
        
        // Hier wird der Eintrag wirklich erstellt und ist im Entity Manager Context
        let entity = NSEntityDescription.entityForName("WeekType", inManagedObjectContext: context)
        let record = WeekType(entity: entity!, insertIntoManagedObjectContext: context)
        
        record.name = nameTextfield.text!
        record.hours = hours
        record.minutes = selectedMinute
        
        do {
            try record.managedObjectContext?.save()
            navigationController?.popViewControllerAnimated(true)
        } catch {
            print(error)
            showAlert("Fehler", message: "Fehler beim Speichern")
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
            return "\(minutes[row]) Minuten"
        }
    }
    
    
}
