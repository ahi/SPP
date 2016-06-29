//
//  WeekType+CoreDataProperties.swift
//  WeekPlaner
//
//  Created by Ahmet Kiyak on 19.06.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WeekType {

    @NSManaged var hours: NSNumber?
    @NSManaged var minutes: NSNumber?
    @NSManaged var name: String?
    @NSManaged var tasks: NSSet?
    @NSManaged var weekNr: NSSet?

}
