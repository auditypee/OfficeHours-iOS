//
//  InstructorObject.swift
//  OfficeHours
//
//  Created by Audi on 12/3/18.
//  Copyright © 2018 Audi. All rights reserved.
//

import UIKit

struct InstructorObject {
    var instructorID: String
    var name: String
    var officeRoom: String
    var officeDays: [InstOHObject]
}

struct InstOHObject {
    var officeDay: String
    var officeHours: String
}
