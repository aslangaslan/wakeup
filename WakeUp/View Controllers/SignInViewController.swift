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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func signInButtonAction(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        FirebaseClient.signIn(withEmail: email, password: password, completionHandler: handleSignIn(authResult:error:))
        handleLoading(withLoading: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func handleLoading(withLoading isLoading: Bool) {
        view.isUserInteractionEnabled = !isLoading
        if isLoading { activityIndicator.startAnimating() }
        else { activityIndicator.stopAnimating() }
    }
    
}

// MARK:- Keyboard Handler Methods

extension SignInViewController {
    
    @objc func keyboardWillShow(sender: NSNotification) {
        UIView.animate(withDuration: 0.5, animations: { self.view.frame.origin.y = -90 }, completion: nil)
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        UIView.animate(withDuration: 0.5, animations: { self.view.frame.origin.y = 0 }, completion: nil)
    }
    
}

// MARK:- Handler Methods

extension SignInViewController {

    func handleSignIn(authResult: AuthDataResult?, error: Error?) {
        handleLoading(withLoading: false)
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

// MARK:- Textfield Delegate Method

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
