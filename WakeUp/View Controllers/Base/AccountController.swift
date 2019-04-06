//
//  AccountController.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 5.04.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountController: UINavigationController, UINavigationControllerDelegate {
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(signIn), name: .signIn, object: nil)
        debugPrint("Account controller user uid: \(self.user?.uid ?? "")")
        
        handleUserIsLogged()
    }
    
    @objc func signIn(notification: Notification) {
        guard let userDictionary = notification.userInfo as? [String: User] else { return }
        
        if let user = userDictionary["User"]{
            self.user = user
            debugPrint("Account controller signed id successfully...")
        }
        handleUserIsLogged()
    }
}

// MARK:- Handler Methods

extension AccountController {
    
    func handleUserIsLogged() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let user = self.user else {
            let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewController")
            self.setViewControllers([loggedInViewController], animated: false)
            return
        }
        
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "LoggedInViewController") as! LoggedInViewController
        loggedInViewController.user = user
        self.setViewControllers([loggedInViewController], animated: false)
    }
    
}
