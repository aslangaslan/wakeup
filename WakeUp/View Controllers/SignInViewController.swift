//
//  AccountViewController.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 5.04.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {
    
    let signInSegueIdentifier = "showSignedInViewController"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButtonExtension!
    
    @IBAction func signInButtonAction(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        FirebaseClient.signIn(withEmail: email, password: password, completionHandler: handleSignIn(authResult:error:))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func handleSignIn(authResult: AuthDataResult?, error: Error?) {
        
        // Check Sign In Result
        guard let _ = authResult?.user else {
            let alert = UIAlertController(title: "Sign In Failure", message: error!.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        handleLoggedInViewAppear()
    }
    
    func handleLoggedInViewAppear() {
        
        // Instantiate Signed In View Controller
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "LoggedInViewController") as! LoggedInViewController
        
        // Show Logged In View Controller
        navigationController?.setViewControllers([loggedInViewController], animated: true)
    }
}
