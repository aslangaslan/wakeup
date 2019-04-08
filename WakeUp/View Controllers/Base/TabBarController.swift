//
//  TabBarController.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 5.04.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import UIKit
import FirebaseAuth

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    var user:User?
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(signOut), name: .signOut, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signIn), name: .signIn, object: nil)

        FirebaseClient.isUserSignedIn(completionHandler: handleIsUserLoggedIn(user:))
    }
    
    func handleIsUserLoggedIn(user: User?) {
        debugPrint("TabBar user UID is: \(String(describing: user?.uid))")
        guard let user = user else { return }
        self.user = user
    }
    
    @objc func signOut() {
        debugPrint("Signed out successfully...")
        self.user = nil
    }
    
    @objc func signIn(notification: Notification) {
        guard let userDictionary = notification.userInfo as? [String: User] else { return }
        if let user = userDictionary["User"]{
            self.user = user
            debugPrint("Tabbar controller signed in successfully...")
        }
    }
}

// MARK:- Tabbar Methods

extension TabBarController {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        switch viewController {
        case is SetAlarmViewController:
            (viewController as! SetAlarmViewController).user = user
            (viewController as! SetAlarmViewController).dataController = dataController
            debugPrint("Set alarm tab is selected...")
        case is ReportViewController:
            (viewController as! ReportViewController).user = user
            (viewController as! ReportViewController).dataController = dataController
            debugPrint("Report tab is selected...")
        case is SettingsViewController:
            debugPrint("Settings controller tab is selected...")
        case is AccountController:
            (viewController as! AccountController).user = user
            debugPrint("Account controller tab is selected...")
        default:
            return true
        }
        return true
    }
}
