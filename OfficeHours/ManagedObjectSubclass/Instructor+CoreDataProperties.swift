//
//  Instructor+CoreDataProperties.swift
//  OfficeHours
//
//  Created by Audi on 12/6/18.
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

}
