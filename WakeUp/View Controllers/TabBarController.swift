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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.delegate = self
        tabBarController?.selectedIndex = 2
        
        FirebaseClient.isUserSignedIn(completionHandler: handleIsUserLoggedIn(user:))
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let selectedViewController = viewController as? SetAlarmViewController {
            selectedViewController.userUID = self.user?.uid
        }
    }
    
    func handleIsUserLoggedIn(user: User?) {
        debugPrint("TabBar user UID is: \(user?.uid)")
        guard let user = user else { return }
        self.user = user
    }
}
