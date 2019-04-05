//
//  CreateAccountViewController.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 5.04.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak internal var displayNameTextField: UITextField!
    @IBOutlet weak internal var emailTextField: UITextField!
    @IBOutlet weak internal var passwordTextField: UITextField!
    
    @IBAction func createUserButtonAction(_ sender: Any) {
        guard
            let _ = displayNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text
            else {
                return
        }
        FirebaseClient.createUser(withEmail: email, password: password, completionHandler: handleCreateUser(authResult:error:))
    }
    
    func handleCreateUser(authResult: AuthDataResult?, error: Error?) {
        guard let _ = authResult else {
            let alert = UIAlertController(title: "Create User Error", message: error.debugDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil) }))
            show(alert, sender: nil)
            return
        }
        guard let displayName = displayNameTextField.text else { return }
        FirebaseClient.createProfileChangeRequest(withDisplayName: displayName, completionHandler: handleProfileChangeRequest(error:))
    }
    
    func handleProfileChangeRequest(error: Error?) {
        guard let error = error else {
            let alert = UIAlertController(title: "Profile Change Success", message: "User creation is complete", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
                
                // Instantiate Signed In View Controller
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "LoggedInViewController") as! LoggedInViewController
                
                // Show Logged In View Controller
                self.navigationController?.setViewControllers([loggedInViewController], animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let alert = UIAlertController(title: "Profile Change Failure", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil) }))
        self.present(alert, animated: true, completion: nil)
    }
}
