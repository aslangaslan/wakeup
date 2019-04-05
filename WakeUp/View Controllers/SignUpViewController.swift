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
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createUserButtonAction(_ sender: Any) {
        
        guard let displayName = displayNameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            let alert = UIAlertController(title: "Create User Error", message: "Please fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard displayName.count > 6, email.count > 6, password.count > 6 else {
            let alert = UIAlertController(title: "Create User Error", message: "All fields must be at least 6 characters long", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        FirebaseClient.createUser(withEmail: email, password: password, completionHandler: handleCreateUser(authResult:error:))
    }

}

// MARK:- Handler Methods

extension SignUpViewController {
    
    func handleCreateUser(authResult: AuthDataResult?, error: Error?) {
        guard let _ = authResult else {
            let alert = UIAlertController(title: "Create User Error", message: error.debugDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true, completion: nil)
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
