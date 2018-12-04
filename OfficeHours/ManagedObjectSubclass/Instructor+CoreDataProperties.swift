//
//  Instructor+CoreDataProperties.swift
//  OfficeHours
//
//  Created by Audi on 12/3/18.
//  Copyright © 2018 Audi. All rights reserved.
//
//

import Foundation
import CoreData


extension Instructor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Instructor> {
        return NSFetchRequest<Instructor>(entityName: "Instructor")
    }

    @NSManaged public var inst_name: String?
    @NSManaged public var inst_office_room: String?
    @NSManaged public var courses: NSSet?
    @NSManaged public var inst_office_hours: NSSet?

}

// MARK: Generated accessors for courses
extension Instructor {

    @objc(addCoursesObject:)
    @NSManaged public func addToCourses(_ value: Course)

    @objc(removeCoursesObject:)
    @NSManaged public func removeFromCourses(_ value: Course)

    @objc(addCourses:)
    @NSManaged public func addToCourses(_ values: NSSet)

    @objc(removeCourses:)
    @NSManaged public func removeFromCourses(_ values: NSSet)

}

// MARK: Generated accessors for inst_office_hours
extension Instructor {

    @objc(addInst_office_hoursObject:)
    @NSManaged public func addToInst_office_hours(_ value: Inst_Office_Hours)

    @objc(removeInst_office_hoursObject:)
    @NSManaged public func removeFromInst_office_hours(_ value: Inst_Office_Hours)

    @objc(addInst_office_hours:)
    @NSManaged public func addToInst_office_hours(_ values: NSSet)

    @objc(removeInst_office_hours:)
    @NSManaged public func removeFromInst_office_hours(_ values: NSSet)

}
