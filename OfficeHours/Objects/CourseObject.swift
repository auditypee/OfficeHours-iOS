//
//  CourseObject.swift
//  OfficeHours
//
//  Created by Audi on 12/3/18.
//  Copyright © 2018 Audi. All rights reserved.
//

import UIKit

struct CourseObject: Decodable {
    var days: String
    var hours: String
    var name: String
    var num: String
    var room: String
}
