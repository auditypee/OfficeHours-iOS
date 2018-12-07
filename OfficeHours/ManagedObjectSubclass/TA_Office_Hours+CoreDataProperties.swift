//
//  TA_Office_Hours+CoreDataProperties.swift
//  OfficeHours
//
//  Created by Audi on 12/6/18.
//  Copyright © 2018 Audi. All rights reserved.
//
//

import Foundation
import CoreData


extension TA_Office_Hours {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TA_Office_Hours> {
        return NSFetchRequest<TA_Office_Hours>(entityName: "TA_Office_Hours")
    }

    @NSManaged public var office_day: String?
    @NSManaged public var office_hours: String?
    @NSManaged public var ta: TA?

}
