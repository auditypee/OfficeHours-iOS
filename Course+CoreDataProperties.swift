//
//  Course+CoreDataProperties.swift
//  OfficeHours
//
//  Created by Audi on 12/12/18.
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
    @NSManaged public var course_id: Int16
    @NSManaged public var inst_id: Int16
    @NSManaged public var instructor: Instructor?
    @NSManaged public var tas: NSSet?

}

// MARK: Generated accessors for tas
extension Course {

    @objc(addTasObject:)
    @NSManaged public func addToTas(_ value: TA)

    @objc(removeTasObject:)
    @NSManaged public func removeFromTas(_ value: TA)

    @objc(addTas:)
    @NSManaged public func addToTas(_ values: NSSet)

    @objc(removeTas:)
    @NSManaged public func removeFromTas(_ values: NSSet)

}
