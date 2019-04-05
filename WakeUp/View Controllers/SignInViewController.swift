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
    
}

// MARK:- Handler Methods

extension SignInViewController {

    func handleSignIn(authResult: AuthDataResult?, error: Error?) {
        guard let user = authResult?.user else {
            let alert = UIAlertController(title: "Sign In Failure", message: error!.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let userDictionary: [String: User] = ["User": user]
        NotificationCenter.default.post(name: .signIn, object: nil, userInfo: userDictionary)
    }
}

// MARK:- Core Data Methods

extension SignInViewController {
    
    func saveToCoreDate(user: User) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let userEntity = UserEntity(context: appDelegate.dataController.viewContext)
        userEntity.displayName = user.displayName
        userEntity.email = user.email
        
        do {
            try userEntity.save()
        }
        catch {
            
        }
    }
    
}
