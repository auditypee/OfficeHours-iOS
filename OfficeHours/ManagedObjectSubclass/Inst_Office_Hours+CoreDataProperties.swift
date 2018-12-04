//
//  Inst_Office_Hours+CoreDataProperties.swift
//  OfficeHours
//
//  Created by Audi on 12/3/18.
//  Copyright © 2018 Audi. All rights reserved.
//
//

import Foundation
import CoreData


extension Inst_Office_Hours {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Inst_Office_Hours> {
        return NSFetchRequest<Inst_Office_Hours>(entityName: "Inst_Office_Hours")
    }

    @NSManaged public var office_days: String?
    @NSManaged public var office_hours: String?
    @NSManaged public var instructor: Instructor?

}
