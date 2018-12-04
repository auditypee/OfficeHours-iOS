//
//  TA+CoreDataProperties.swift
//  OfficeHours
//
//  Created by Audi on 12/3/18.
//  Copyright © 2018 Audi. All rights reserved.
//
//

import Foundation
import CoreData


extension TA {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TA> {
        return NSFetchRequest<TA>(entityName: "TA")
    }

    @NSManaged public var ta_name: String?
    @NSManaged public var ta_office_room: String?
    @NSManaged public var course: Course?
    @NSManaged public var ta_office_hours: NSSet?

}

// MARK: Generated accessors for ta_office_hours
extension TA {

    @objc(addTa_office_hoursObject:)
    @NSManaged public func addToTa_office_hours(_ value: TA_Office_Hours)

    @objc(removeTa_office_hoursObject:)
    @NSManaged public func removeFromTa_office_hours(_ value: TA_Office_Hours)

    @objc(addTa_office_hours:)
    @NSManaged public func addToTa_office_hours(_ values: NSSet)

    @objc(removeTa_office_hours:)
    @NSManaged public func removeFromTa_office_hours(_ values: NSSet)

}
