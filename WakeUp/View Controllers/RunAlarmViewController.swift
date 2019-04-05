//
//  ScreenSaverViewController.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 9.03.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import UIKit
import AVKit

class RunAlarmViewController: UIViewController {
    
    // Variables
    var alarm: Alarm!
    var torchIsOn: Bool = false

    // Outlets
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var alarmLabel: UILabel!
    
    @IBOutlet weak var cancelAlarmLabel: UILabel!
    
    @IBOutlet weak var snoozeButton: UIButton!
    
    @IBAction func toggleTorch(_ sender: Any) {
        torchIsOn.toggle()
        toggleTorch(on: torchIsOn)
    }
    
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
        toggleTorch(on: false)
        self.dismiss(animated: true, completion: nil)
    }
}

extension RunAlarmViewController {
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
}
