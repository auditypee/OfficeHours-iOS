//
//  JsonParser.swift
//  OfficeHours
//
//  Created by Audi on 12/3/18.
//  Copyright © 2018 Audi. All rights reserved.
//

import UIKit

class JsonParser: NSObject {
    var courses = [CourseJson]()
    var instructors = [InstructorJson]()
    var tas = [TaJson]()
    
    func extractJsonData(data: Data!) {
        let decoder = JSONDecoder()
        
        do {
            let coursesData = try decoder.decode(FindCourse.self, from: data!)
            let instructorsData = try decoder.decode(FindInstructor.self, from: data!)
            let tasData = try decoder.decode(FindTa.self, from: data!)
            
            
        } catch {
            print("Error: Can't convert data to JSON")
            print(error)
        }
    }
    
    
    // return the arrays that were created from the json data
    func getCourses() -> [CourseJson]{
        return courses
    }
    
    func getInstructors() -> [InstructorJson] {
        return instructors
    }
    
    func getTas() -> [TaJson] {
        return tas
    }

}

struct FindCourse: Decodable {
    var courses: [CourseJson]
}

struct FindInstructor: Decodable {
    var instructors: [InstructorJson]
}

struct FindTa: Decodable {
    var tas: [TaJson]
}

struct CourseJson: Decodable {
    var name: String!
    var number: String!
    var room: String!
    var day: String!
    var hours: String!
}

struct InstructorJson: Decodable {
    var name: String!
    var officeRoom: String!
    var officeDays: [InstOHJson]
    
    enum CodingKeys: String, CodingKey {
        case name
        case officeRoom = "office_room"
        case officeDays = "office_days"
    }
}

struct InstOHJson: Decodable {
    var officeDay: String!
    var officeHours1: String!
    var officeHours2: String!
    
    enum CodingKeys: String, CodingKey {
        case officeDay = "office_day"
        case officeHours1 = "office_hours"
        case officeHours2 = "office_hours_extra"
    }
}

struct TaJson: Decodable {
    var name: String!
    var officeRoom: String!
    var officeDays: [TaOHJson]
    
    enum CodingKeys: String, CodingKey {
        case name
        case officeRoom = "office_room"
        case officeDays = "office_days"
    }
}

struct TaOHJson: Decodable {
    var officeDay: String!
    var officeHours1: String!
    var officeHours2: String!
    
    enum CodingKeys: String, CodingKey {
        case officeDay = "office_day"
        case officeHours1 = "office_hours"
        case officeHours2 = "office_hours_extra"
    }
}
