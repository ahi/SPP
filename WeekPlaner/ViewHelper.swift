//
//  ViewHelper.swift
//  WeekPlaner
//
//  Created by Seydi Ahmet Kiyak on 07.06.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func managedObjectContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }
}
