//
//  Alarm.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 14.03.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import Foundation
import UIKit

class Alarm {
    
    // Enums
    private enum Status {
        case initialize, set, snooze, stop
    }
    
    // Variables
    var initDate: Date
    var fireDate: Date
    var isFireDateEligible: Bool {
        let date = Date().resetSecond
        if fireDate == date { return false }
        else { return true }
    }
    
    var cancelTimeInterval: Int = 5     // Alarmin ne zamana kadar iptal edilecegi (saniye cinsinden)
    var snoozeInterval: Int = 1         // Alarmin ertelenince ne kadar sure sonra tekrar calacagi
    var stepCount: Int = 0
    var stopTimerStepCount: Int = 20    // Alarmin kac adim atildiktan sonra duracagi
    private var status: Status
    
    var displayLink: CADisplayLink?
    var dataController: DataController!
    
    private var timers: [Timer] = []
    
    // Methods
    init(sender: UIViewController, fireDate: Date, dataController: DataController) {
        self.initDate = Date()
        self.fireDate = fireDate
        self.dataController = dataController
        
        self.status = .initialize
        MotionTracking.delegate = self
    }
    
    func set() {
        let timer = Timer(fireAt: self.fireDate, interval: 0, target: self, selector: #selector(ring(sender:)), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: .common)
        self.status = .set
        
        // Add Timers Array
        timers.append(timer)
        
        // Start UI Refreshing
        self.displayLink = CADisplayLink(target: self, selector: #selector(refreshUI))
        self.startRefreshingUI()
        
        // Activate Proximity Sensor
        UIDevice.current.isProximityMonitoringEnabled = true
    }
    
//    func set() -> Bool {
//        if isFireDateEligible {
//            let timer = Timer(fireAt: self.fireDate, interval: 0, target: self, selector: #selector(ring(sender:)), userInfo: nil, repeats: false)
//            RunLoop.current.add(timer, forMode: .common)
//            self.status = .set
//
//            // Add Timers Array
//            timers.append(timer)
//
//            // Start UI Refreshing
//            self.displayLink = CADisplayLink(target: self, selector: #selector(refreshUI))
//            self.startRefreshingUI()
//
//            // Activate Proximity Sensor
//            UIDevice.current.isProximityMonitoringEnabled = true
//
//            return true
//        }
//        else {
//            return false
//        }
//    }
    
    @objc private func ring(sender timer: Timer) {
        if self.stepCount > stopTimerStepCount {
            debugPrint("Alarm Stopped ...")
            MotionTracking.stopTrackingMotion()
            
            self.saveToCoreData()
            
            guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
            guard let presentedViewController = rootViewController.presentedViewController as? RunAlarmViewController else { return }
            presentedViewController.dismiss(animated: true, completion: nil)
        } else {
            debugPrint("Ring Ring Ring ...")
            MotionTracking.startTrackingMotion()
            
            guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
            guard let presentedViewController = rootViewController.presentedViewController as? RunAlarmViewController else { return }
            presentedViewController.snoozeButton.isHidden = false
        }
        timer.invalidate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { self.stopRefreshingUI() })
    }
    
    func snoozeAlarm() {
        debugPrint("Snooze Snooze Snooze ...")
        
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
        guard let presentedViewController = rootViewController.presentedViewController as? RunAlarmViewController else { return }
        presentedViewController.snoozeButton.isHidden = true
        
        let timeInterval = TimeInterval(snoozeInterval * 60)
        self.fireDate = self.fireDate.addingTimeInterval(timeInterval)
        self.set()
    }
    
    func getStepCount() -> Int {
        return self.stepCount
    }
    
    func invalidate() {
        self.timers.forEach({ (timer) in
            timer.invalidate()
        })
        self.stopRefreshingUI()
    }
}

//MARK:- Helper Methods

extension Alarm {
    @objc func refreshUI() {
        // Print Outputs
        debugPrint("Date: " + Date().description)
        
        // Refresh UI Components
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
        guard let presentedViewController = rootViewController.presentedViewController as? RunAlarmViewController else { return }
        presentedViewController.timeLabel.text = Date().time(isSecondVisible: false)
        presentedViewController.alarmLabel.text = fireDate.time(isSecondVisible: false)
        
        // Hide Cancel Button After Expiration Time
        let second = Int(Date().timeIntervalSince(self.initDate))
        if second == cancelTimeInterval {
            UIView.animate(withDuration: 1) {
                presentedViewController.cancelAlarmLabel.isHidden = true
            }
        }
    }
    
    func startRefreshingUI() {
        displayLink?.add(to: .current, forMode: .common)
    }
    
    func stopRefreshingUI() {
        displayLink?.remove(from: .current, forMode: .common)
    }
}

//MARK:- Motion Tracking Delegate

extension Alarm: MotionTrackingDelegate {
    func updateStepCount(withParameter stepCount: Int) {
        self.stepCount = stepCount
        debugPrint("Alarm class step count is: " + stepCount.description)
    }
}

//MARK:- Core Data Methods

extension Alarm {
    func saveToCoreData() {
        let alarmEntity = AlarmEntity(context: dataController.viewContext)
        
        alarmEntity.sleepTime = self.initDate
        alarmEntity.wakeUpTime = self.fireDate
        alarmEntity.alarmIsTerminated = false
        alarmEntity.delayCount = 0
        alarmEntity.mood = 1
        
        do {
            try alarmEntity.save()
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
}
