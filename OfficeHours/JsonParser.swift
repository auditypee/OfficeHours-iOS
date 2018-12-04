//
//  JsonParser.swift
//  OfficeHours
//
//  Created by Audi on 12/3/18.
//  Copyright © 2018 Audi. All rights reserved.
//

import UIKit

class JsonParser: NSObject {
    var courses = [CourseObject]()
    var instructors = [InstructorObject]()
    var tas = [TaObject]()
    
    /*
     will extract the json data from the given data
     will take the extracted json data and place it in the corresponding array
     */
    func extractJsonData(data: Data!) {
        let decoder = JSONDecoder()
        
        do {
            let coursesData = try decoder.decode(FindCourse.self, from: data!)
            let instructorsData = try decoder.decode(FindInstructor.self, from: data!)
            let tasData = try decoder.decode(FindTa.self, from: data!)
            
            for course in coursesData.course {
                let day = course.day!
                let hours = course.hours!
                let name = course.name!
                let number = course.number!
                let room = course.room!
                
                courses.append(CourseObject(days: day, hours: hours, name: name, num: number, room: room))
            }
            
            // TODO: - Implement instructors in object
            for instructor in instructorsData.instructor {
                print(instructor.name)
            }
            
            // TODO: - Implement tas into object
            for ta in tasData.ta {
                print(ta.name)
            }
            
        } catch {
            print("Error: Can't convert data to JSON")
            print(error)
        }
    }
    
    
    // return the arrays that were created from the json data
    func getCourses() -> [CourseObject]{
        return courses
    }
    
    func getInstructors() -> [InstructorObject] {
        return instructors
    }
    
    func getTas() -> [TaObject] {
        return tas
    }

}

struct FindCourse: Decodable {
    var course: [CourseJson]
}

struct CourseJson: Decodable {
    var name: String!
    var number: String!
    var room: String!
    var day: String!
    var hours: String!
}

struct FindInstructor: Decodable {
    var instructor: [InstructorJson]
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

struct FindTa: Decodable {
    var ta: [TaJson]
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
