//
//  TA+CoreDataProperties.swift
//  OfficeHours
//
//  Created by Audi on 12/6/18.
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

}
