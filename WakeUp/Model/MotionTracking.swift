//
//  MotionTracking.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 23.03.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import Foundation
import CoreMotion

protocol MotionTrackingDelegate {
    func updateStepCount(withParameter stepCount: Int)
}

class MotionTracking {
    
    public static var delegate: MotionTrackingDelegate!
    
    private static let pedometer = CMPedometer()
    
    private static let activityManager = CMMotionActivityManager()
    
    private class func startTrackingActivityType() {
        activityManager.startActivityUpdates(to: OperationQueue.main) { (activity: CMMotionActivity?) in
            guard let activity = activity else { return }
            DispatchQueue.main.async {
                if activity.walking {
                    debugPrint("Walking")
                } else if activity.stationary {
                    debugPrint("Stationary")
                } else if activity.running {
                    debugPrint("Running")
                } else if activity.automotive {
                    debugPrint("Automotive")
                }
            }
        }
    }
    
    private class func startCountingSteps() {
        pedometer.startUpdates(from: Date()) { pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            DispatchQueue.main.async {
                let stepCount = pedometerData.numberOfSteps.intValue
                self.delegate.updateStepCount(withParameter: stepCount)
                debugPrint("Motion tracking step count is: " + stepCount.description)
            }
        }
    }
    
    public class func startTrackingMotion() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        }
        
        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps()
        }
    }
    
    public class func stopTrackingMotion() {
        pedometer.stopUpdates()
        activityManager.stopActivityUpdates()
    }
}
