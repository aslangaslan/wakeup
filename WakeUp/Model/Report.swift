//
//  Report.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 14.03.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import Foundation

struct Report {
    var date: Date
    
    var sleepDate: Date
    
    var wakeUpDate: Date
    
    var totalHour: Int
    
    var mood: Mood
    
    enum Mood {
        case happy, average, tired
    }
}
