//
//  ViewController.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 6.03.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import UIKit
import AVFoundation

class SetAlarmViewController: UIViewController {

    // MARK:- Variables
    
    let device:UIDevice = UIDevice.current
    
    var player = AVAudioPlayer()
    
    var selectedDate: Date!
    
    var fireDate: Date {
        //debugPrint("Compund property - Fire date: " + date.description + "|" + "Date: " + Date().resetSecond.description)
        if self.selectedDate.resetSecond < Date().resetSecond { return self.selectedDate.addingTimeInterval(TimeInterval(86400)) }
        else { return self.selectedDate }
    }
    
    var alarm: Alarm?
    
    let segueIdentifier = "ShowRunAlarmViewController"
    
    // MARK:- Outlets
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK:- Actions
    
    @IBAction func setAlarmAction(_ sender: Any) {
        setAlarm()
    }
    
    @IBAction func datePickerAction(_ sender: Any) {
        debugPrint(datePicker.date.resetSecond)
        self.selectedDate = datePicker.date.resetSecond
    }
    
    // MARK:- Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.locale = Locale.current
        datePicker.timeZone = TimeZone.current
        self.selectedDate = datePicker.date.resetSecond
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? RunAlarmViewController else { return }
        guard let alarm = self.alarm else { return }
        destination.alarm = alarm
    }
}

// MARK:- Helper Methods

extension SetAlarmViewController {
    
    func setAlarm() {
        self.alarm = Alarm(sender: self, fireDate: fireDate)
        guard let alarm = self.alarm else { return }
        
        if alarm.set() { performSegue(withIdentifier: segueIdentifier, sender: self) }
        else { debugPrint("Fire date is not eligible!") }
    }
}
