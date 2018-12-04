//
//  Course+CoreDataProperties.swift
//  OfficeHours
//
//  Created by Audi on 12/3/18.
//  Copyright © 2018 Audi. All rights reserved.
//
//

import Foundation
import CoreData


extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var course_days: String?
    @NSManaged public var course_hours: String?
    @NSManaged public var course_name: String?
    @NSManaged public var course_num: String?
    @NSManaged public var course_room: String?
    @NSManaged public var instructor: Instructor?
    @NSManaged public var ta: NSSet?

}

// MARK: Generated accessors for ta
extension Course {

    @objc(addTaObject:)
    @NSManaged public func addToTa(_ value: TA)

    @objc(removeTaObject:)
    @NSManaged public func removeFromTa(_ value: TA)

    @objc(addTa:)
    @NSManaged public func addToTa(_ values: NSSet)

    @objc(removeTa:)
    @NSManaged public func removeFromTa(_ values: NSSet)

}
