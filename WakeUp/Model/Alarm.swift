//
//  Alarm.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 14.03.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import AVFoundation

class Alarm {
    
    // Variables
    
    var initDate: Date
    var fireDate: Date
    var duration: Double {
        print("Duration is: \(self.fireDate.timeIntervalSince(self.initDate) / 3600) hours")
        return self.fireDate.timeIntervalSince(self.initDate) / 60
    }
    var userUID: String!
    var stepCount: Int = 0
    var settings: Settings {
        let data = UserDefaults.standard.data(forKey: "settings-data")!
        let settings = NSKeyedUnarchiver.unarchiveObject(with: data) as! Settings
        return settings
    }
    
    // Step Count to Stop Alarm
    var alarmStopStepCount: Int {
        return settings.alarmStopStepCount
    }
    
    // Snooze Interval
    var snoozeInterval: Int {
        return settings.snoozeInterval
    }
    
    var displayLink: CADisplayLink?
    var dataController: DataController!
    
    private var timers: [Timer] = []
    
    // AVFoundation Variables
    
    var player = AVAudioPlayer()
    
    // Methods
    
    init(sender: UIViewController, fireDate: Date, dataController: DataController, userUID: String) {
        self.initDate = Date().resetSecond
        self.fireDate = fireDate
        self.dataController = dataController
        self.userUID = userUID
        MotionTracking.delegate = self
        
        //debugPrint("Alarm object user UID is: \(userUID)")
        print("Alarm object fire date: \(self.fireDate)")
    }
    
    func set() {
        let timer = Timer(fireAt: self.fireDate, interval: 0, target: self, selector: #selector(ring(sender:)), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: .common)
        
        // Add Timers Array
        timers.append(timer)
        
        // Start UI Refreshing
        self.displayLink = CADisplayLink(target: self, selector: #selector(refreshUI))
        self.startRefreshingUI()
        
        // Activate Proximity Sensor
        UIDevice.current.isProximityMonitoringEnabled = true
    }
    
    @objc private func ring(sender timer: Timer) {
        
        if self.stepCount > alarmStopStepCount {
            self.stopSound()
            self.save()
            MotionTracking.stopTrackingMotion()
            
            guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
            guard let presentedViewController = rootViewController.presentedViewController as? RunAlarmViewController else { return }
            presentedViewController.dismiss(animated: true, completion: nil)
        }
        else {
            self.playSound()
            MotionTracking.startTrackingMotion()
            
            guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
            guard let presentedViewController = rootViewController.presentedViewController as? RunAlarmViewController else { return }
            presentedViewController.snoozeButton.isHidden = false
            presentedViewController.cancelView.isHidden = true
            presentedViewController.downSwipeGesture.isEnabled = false
        }
        
        timer.invalidate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { self.stopRefreshingUI() })
    }
    
    func snoozeAlarm() {
        debugPrint("Snooze Snooze Snooze ...")
        
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
        guard let presentedViewController = rootViewController.presentedViewController as? RunAlarmViewController else { return }
        presentedViewController.snoozeButton.isHidden = true
        
        stopSound()
        let timeInterval = TimeInterval(snoozeInterval * 60)
        self.fireDate = self.fireDate.addingTimeInterval(timeInterval)
        self.set()
    }
    
    func invalidate() {
        
        // For testing core data, you can un-comment this line
        // self.save()
        
        self.timers.forEach({ (timer) in
            timer.invalidate()
        })
        self.stopRefreshingUI()
    }
    
    private func save() {
        let initHour = Calendar.current.component(.hour, from: initDate)
        debugPrint("Init hour :\(initHour)")
        
        if initHour > 21, duration > 6 {
            self.saveToCoreData()
        }
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
        alarmEntity.date = self.initDate
        alarmEntity.duration = self.duration
        alarmEntity.mood = 1
        
        do {
            try alarmEntity.save()
            print("Core data saved...")
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
}

// MARK:- Play Sound

extension Alarm {
    
    func playSound() {
        
        guard let url = Bundle.main.url(forResource: "alarm-sound", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound() {
        if player.isPlaying { player.stop() }
    }
    
}
