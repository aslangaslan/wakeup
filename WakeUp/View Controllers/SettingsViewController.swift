//
//  SettingsViewController.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 3.04.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UITableViewController {
    
    var settings: Settings?
    
    @IBOutlet weak var snoozeTimeLabel: UILabel!
    @IBOutlet weak var stepCountLabel: UILabel!
    @IBOutlet weak var snoozeTimeStepper: UIStepper!
    @IBOutlet weak var stepCountStepper: UIStepper!
    
    @IBAction func actionSnoozeTimeStepper(_ sender: Any) {
        snoozeTimeLabel.text = "\(Int(snoozeTimeStepper.value)) mins"
    }
    
    @IBAction func actionStepCountStepper(_ sender: Any) {
        stepCountLabel.text = "\(Int(stepCountStepper.value)) steps"
    }
    
    @IBAction func save(_ sender: Any) {
        let settings = Settings(snoozeInterval: Int(snoozeTimeStepper.value), alarmStopStepCount: Int(stepCountStepper.value))
        let data =  try? NSKeyedArchiver.archivedData(withRootObject: settings, requiringSecureCoding: false)
        UserDefaults.standard.set(data, forKey: "settings-data")
        let alert = UIAlertController(title: "Saved", message: "Your settings has been saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil) }))
        show(alert, sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPersistentData()
    }
}

// Core Data

extension SettingsViewController {
    
    fileprivate func setupPersistentData() {
        if let data = UserDefaults.standard.data(forKey: "settings-data") {
            if let settings = NSKeyedUnarchiver.unarchiveObject(with: data) as? Settings {
                self.snoozeTimeLabel.text = "\(settings.snoozeInterval.description) mins"
                self.stepCountLabel.text = "\(settings.alarmStopStepCount.description) steps"
                self.snoozeTimeStepper.value = Double(settings.snoozeInterval)
                self.stepCountStepper.value = Double(settings.alarmStopStepCount)
            }
        }
    }
}
