//
//  CheckAvailability.swift
//  OfficeHours
//
//  Created by Audi on 12/12/18.
//  Copyright © 2018 Audi. All rights reserved.
//

/*
 Compares a given time range and day to current time and day
 Will return a boolean
 
 */
import UIKit
class CheckAvailability: NSObject {
    func checkAvailability(timeString: String, officeDay: String) -> Bool {
        return separateStrings(timeString: timeString) && checkDays(officeDay: officeDay)
    }
    
    // assumes the given string is of the format hh:mma - hh:mma#hh:mma - hh:mma
    func separateStrings(timeString: String) -> Bool {
        // separates the string by the delimiter '#'
        var hoursArr = timeString.components(separatedBy: "#")
        
        let hours1 = hoursArr[0]
        let hours2 = hoursArr[1]
        
        // separates the first time string by the range '-'
        hoursArr = hours1.components(separatedBy: "-")
        let h1Start = hoursArr[0]
        let h1End = hoursArr[1]
        
        // passes the two strings to check if the current time is between the range
        let h1 = checkHours(hoursStart: h1Start, hoursEnd: h1End)
        var h2 = false
        
        if (!hours2.isEmpty) {
            hoursArr = hours2.components(separatedBy: "-")
            
            let h2Start = hoursArr[0]
            let h2End = hoursArr[1]
            
            h2 = checkHours(hoursStart: h2Start, hoursEnd: h2End)
        }
        
        // if any of the checks are true, return true
        return h1 || h2
    }
    
    // converts the given string to a date format and compares it to the current time
    // checks if the current time is within the time range
    func checkHours(hoursStart: String, hoursEnd: String) -> Bool{
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "hh:mma"
        
        let outFormatter = DateFormatter()
        outFormatter.dateFormat = "HH:mm"
        
        let startHours = inFormatter.date(from: hoursStart)!
        let endHours = inFormatter.date(from: hoursEnd)!
        
        let now = Date()
        inFormatter.dateFormat = "HH:mm"
        let noSH = outFormatter.string(from: now)
        let nowHours = inFormatter.date(from: noSH)!
        
        return nowHours >= startHours && nowHours <= endHours
    }
    
    // compares the given office day to the current week day
    func checkDays(officeDay: String) -> Bool {
        let outFormatter = DateFormatter()
        outFormatter.dateFormat = "EEEE"
        
        let today = Date()
        let day = outFormatter.string(from: today)
        
        return day == officeDay
    }
}
