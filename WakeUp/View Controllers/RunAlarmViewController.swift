//
//  ScreenSaverViewController.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 9.03.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import UIKit

class RunAlarmViewController: UIViewController {
    
    // Variables
    var alarm: Alarm!

    // Outlets
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var alarmLabel: UILabel!
    
    @IBOutlet weak var cancelAlarmLabel: UILabel!
    
    @IBOutlet weak var snoozeButton: UIButton!
    
    @IBAction func snoozeAction(_ sender: Any) {
        self.alarm.snoozeAlarm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleDownSwipeGesture))
        downSwipeGesture.direction = .down
        self.view.addGestureRecognizer(downSwipeGesture)
    }
    
    @objc func handleDownSwipeGesture() {
        self.alarm.invalidate()
        self.alarm = nil
        self.dismiss(animated: true, completion: nil)
    }
}
