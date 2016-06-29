//
//  WeekNr+CoreDataProperties.swift
//  WeekPlaner
//
//  Created by Seydi Ahmet Kiyak on 29.06.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WeekNr {

    @NSManaged var week: NSNumber?
    @NSManaged var year: NSNumber?
    @NSManaged var finished: NSNumber?
    @NSManaged var weekType: WeekType?

}
