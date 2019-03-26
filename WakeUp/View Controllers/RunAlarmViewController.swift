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

        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe))
        rightSwipeGesture.direction = .right
        self.view.addGestureRecognizer(rightSwipeGesture)
    }
    
    @objc func handleRightSwipe() {
        self.alarm.invalidate()
        self.alarm = nil
        self.dismiss(animated: true, completion: nil)
    }
}
