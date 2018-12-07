//
//  Course+CoreDataProperties.swift
//  OfficeHours
//
//  Created by Audi on 12/6/18.
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

}
