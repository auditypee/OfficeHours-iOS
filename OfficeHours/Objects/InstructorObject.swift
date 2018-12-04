//
//  InstructorObject.swift
//  OfficeHours
//
//  Created by Audi on 12/3/18.
//  Copyright © 2018 Audi. All rights reserved.
//

import UIKit

struct InstructorObject {
    var name: String
    var officeRoom: String
    var officeDays: [InstOfficeHours]
}

struct InstOfficeHours {
    var officeDay: String
    var officeHours: String
}
