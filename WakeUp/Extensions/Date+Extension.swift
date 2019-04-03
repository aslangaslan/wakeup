//
//  Date+Extension.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 16.03.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import Foundation

extension Date {
    
    var resetSecond: Date {
        
        // For Set to "0" on Selected Date
        
        var returnDateComponents: DateComponents = (Calendar.current as NSCalendar).components(NSCalendar.Unit(rawValue: UInt.max), from: self)
        returnDateComponents.second = 00
        returnDateComponents.nanosecond = 00
        return Calendar.current.date(from: returnDateComponents)!
    }
    
    func local() -> Date {
        let secondsFromGMT = TimeZone.current.secondsFromGMT()
        let timeInterval = TimeInterval(secondsFromGMT)
        let localDate = self.addingTimeInterval(timeInterval)
        return localDate
    }
    
    func time(isSecondVisible: Bool) -> String {
        
        let hour = Calendar.current.component(.hour, from: self)
        let minute = Calendar.current.component(.minute, from: self)
        let second = Calendar.current.component(.second, from: self)
        
        var hourDescription = hour.description
        if hour < 10 { hourDescription = "0" + hour.description }
        
        var minuteDescription = minute.description
        if minute < 10 { minuteDescription = "0" + minute.description }
        
        var secondDescription = second.description
        if second < 10 { secondDescription = "0" + second.description }
        
        if isSecondVisible {
            return hourDescription + ":" + minuteDescription + ":" + secondDescription
        } else {
            return hourDescription + ":" + minuteDescription
        }
    }
}
