//
//  JsonParser.swift
//  OfficeHours
//
//  Created by Audi on 12/3/18.
//  Copyright © 2018 Audi. All rights reserved.
//

import UIKit

class JsonParser: NSObject {
    
    /*
     will extract the json data (courses) from the given data
     will take the extracted json data and place it in the corresponding array
     */
    func extractCourses(data: Data!) -> [CourseObject] {
        var courses: [CourseObject] = []
        let decoder = JSONDecoder()
        
        do {
            // decodes the json array to look for "courses"
            let coursesData = try decoder.decode(FindCourse.self, from: data!)
            
            // creates course objects from json data
            for course in coursesData.course {
                let courseID = course.courseID!
                let instructorID = course.instructorID!
                let day = course.day!
                let hours = course.hours!
                let name = course.name!
                let number = course.number!
                let room = course.room!
                
                courses.append(CourseObject(courseID: courseID, instructorID: instructorID, days: day, hours: hours, name: name, num: number, room: room))
            }
        } catch {
            print("Error: Can't extract courses from JSON \(error)")
        }
        
        return courses
    }
    
    /*
     will extract the json data (instructors) from the given data
     will take the extracted json data and place it in the corresponding array
     */
    func extractInstructors(data: Data!) -> [InstructorObject] {
        var instructors: [InstructorObject] = []
        let decoder = JSONDecoder()
        
        do {
            // decodes the json array to look for "instructors"
            let instructorsData = try decoder.decode(FindInstructor.self, from: data!)
            
            
            for instructor in instructorsData.instructor {
                // decodes the json array to look for "office_days"
                //let instOfficeHours = try decoder.decode(InstructorJson.self, from: data!)
                
                // empty the object
                var iohObjects: [InstOHObject] = []
                
                let instID = instructor.instructorID!
                let name = instructor.name!
                let officeRoom = instructor.officeRoom!
                
                // initializes the office hours array from the json data
                for ioh in instructor.officeDays {
                    if (!ioh.officeDay.isEmpty) {
                        let officeDay = ioh.officeDay!
                        let officeHours1 = ioh.officeHours1!
                        let officeHours2 = ioh.officeHours2!
                        // combines the two office hours to one string
                        // # used to separate the string for later
                        let officeHours = officeHours1 + "#" + officeHours2
                        // creates the office hours into an object
                        iohObjects.append(InstOHObject(officeDay: officeDay, officeHours: officeHours))
                    }
                }
                
                instructors.append(InstructorObject(instructorID: instID, name: name, officeRoom: officeRoom, officeDays: iohObjects))
            }
        } catch {
            print("Error: Can't extract instructors from JSON \(error)")
        }
        
        return instructors
    }
    
    /*
     will extract the json data (tas) from the given data
     will take the extracted json data and place it in the corresponding array
     */
    func extractTAs(data: Data!) -> [TaObject] {
        var tas: [TaObject] = []
        let decoder = JSONDecoder()
        
        do {
            let tasData = try decoder.decode(FindTa.self, from: data!)
            
            
            for ta in tasData.ta {
                var tohObjects: [TaOHObject] = []
                
                let courseID = ta.courseID!
                let name = ta.name!
                let officeRoom = ta.officeRoom!
                
                for toh in ta.officeDays {
                    if (!toh.officeDay.isEmpty) {
                        let officeDay = toh.officeDay!
                        let officeHours1 = toh.officeHours1!
                        let officeHours2 = toh.officeHours2!
                        
                        let officeHours = officeHours1 + "#" + officeHours2
                        
                        tohObjects.append(TaOHObject(officeDay: officeDay, officeHours: officeHours))
                    }
                }
                
                tas.append(TaObject(courseID: courseID, name: name, officeRoom: officeRoom, officeDays: tohObjects))
            }
        } catch {
            print("Error: Can't extract tas from JSON \(error)")
        }
        
        return tas
    }

}

// MARK: - Holds the structures that can search specific json data by their keys

// finds the "course" key
struct FindCourse: Decodable {
    var course: [CourseJson]
}

struct CourseJson: Decodable {
    var courseID: String!
    var instructorID: String!
    var name: String!
    var number: String!
    var room: String!
    var day: String!
    var hours: String!
}

// finds the "instructor" key
struct FindInstructor: Decodable {
    var instructor: [InstructorJson]
}

struct InstructorJson: Decodable {
    var instructorID: String!
    var name: String!
    var officeRoom: String!
    var officeDays: [InstOHJson]
    
    enum CodingKeys: String, CodingKey {
        case instructorID = "instructorID"
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

// finds the "ta" key
struct FindTa: Decodable {
    var ta: [TaJson]
}

struct TaJson: Decodable {
    var courseID: String!
    var name: String!
    var officeRoom: String!
    var officeDays: [TaOHJson]
    
    enum CodingKeys: String, CodingKey {
        case courseID
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
