//
//  Settings.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 4.04.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import Foundation

class Settings: NSObject, NSCoding {
    
    var snoozeInterval: Int!
    var alarmStopStepCount : Int!
    
    init(snoozeInterval: Int, alarmStopStepCount: Int) {
        self.snoozeInterval = snoozeInterval
        self.alarmStopStepCount = alarmStopStepCount
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(snoozeInterval, forKey: "snoozeInterval")
        aCoder.encode(alarmStopStepCount, forKey: "alarmStopStepCount")
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        self.init()
        self.snoozeInterval = aDecoder.decodeObject(forKey: "snoozeInterval") as? Int
        self.alarmStopStepCount = aDecoder.decodeObject(forKey: "alarmStopStepCount") as? Int
    }
}
