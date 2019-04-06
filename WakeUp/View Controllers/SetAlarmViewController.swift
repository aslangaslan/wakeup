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
        print("Selected date \(selectedDate.resetSecond) - date reset second \(Date().resetSecond)")
        if selectedDate.resetSecond < Date().resetSecond {
            return selectedDate.addingTimeInterval(TimeInterval(86400))
        }
        else {
            return selectedDate
        }
    }
    
    // Core Data Variables
    
    var dataController: DataController!
    
    // MARK:- Outlets
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK:- Actions
    
    @IBAction func setAlarmAction(_ sender: Any) {
        setAlarm()
    }
    
    @IBAction func datePickerAction(_ sender: Any) {
        self.selectedDate = datePicker.date.resetSecond
        print("Selected date is: \(String(describing: self.selectedDate))")
        print("Fire date is \(self.fireDate)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datePicker.date = Date.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We Need to Delay For ViewDidLoad Completed
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { 
            let alert = UIAlertController(title: "Important Information",
                                          message: "The application must remain open during use and until it is stopped using the number of alarm steps.",
                                          preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true, completion: nil)
        }
        
        datePicker.locale = Locale.current
        datePicker.timeZone = TimeZone.current
        self.selectedDate = datePicker.date.local.resetSecond
        
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
        let current = Date().resetSecond
        if current == fireDate {
            let alert = UIAlertController(title: "Set Alarm Failure", message: "Current time and alarm time can not be same", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        
        
        let userUID = self.user?.uid ?? "0"
        self.alarm = Alarm(sender: self, fireDate: fireDate, dataController: self.dataController, userUID: userUID)
        self.alarm!.set()
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
}
