//
//  ViewController.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 6.03.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth

class SetAlarmViewController: UIViewController {

    // Common Variables
    
    var user: User?
    
    let segueIdentifier = "ShowRunAlarmViewController"
    
    // Alarm Function Variables
    
    var alarm: Alarm?
    
    var selectedDate: Date!
    
    var fireDate: Date {
        if self.selectedDate.resetSecond < Date().resetSecond { return self.selectedDate.addingTimeInterval(TimeInterval(86400)) }
        else { return self.selectedDate }
    }
    
    // Core Data Variables
    
    var dataController: DataController!
    
    // AVFoundation Variables
    
    var player = AVAudioPlayer()
    
    // MARK:- Outlets
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK:- Actions
    
    @IBAction func setAlarmAction(_ sender: Any) {
        setAlarm()
    }
    
    @IBAction func datePickerAction(_ sender: Any) {
        debugPrint(datePicker.date.resetSecond)
        self.selectedDate = datePicker.date.resetSecond
        debugPrint("Selected date is: \(String(describing: self.selectedDate))")
    }
    
    // MARK:- Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.locale = Locale.current
        datePicker.timeZone = TimeZone.current
        self.selectedDate = datePicker.date.resetSecond
        
        FirebaseClient.isUserSignedIn(completionHandler: handleIsUserLoggedIn(user:))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? RunAlarmViewController else { return }
        guard let alarm = self.alarm else { return }
        destination.alarm = alarm
    }
}

// MARK:- Handler Methods

extension SetAlarmViewController {
    
    func handleIsUserLoggedIn(user: User?) {
        guard let user = user else { return }
        self.user = user
    }
    
}

// MARK:- Helper Methods

extension SetAlarmViewController {
    
    func setAlarm() {
        debugPrint("Fire date is: \(String(describing: self.selectedDate))")
        self.alarm = Alarm(sender: self, fireDate: fireDate, dataController: self.dataController, userUID: self.user?.uid)
        guard let alarm = self.alarm else { return }
        
        alarm.set()
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
}
