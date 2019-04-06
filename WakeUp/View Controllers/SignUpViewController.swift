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
import Photos

class SignUpViewController: UIViewController {
    
    var user: User?
    
    @IBOutlet weak var profileImageView: UIImageViewExtension!
    @IBOutlet weak internal var displayNameTextField: UITextField!
    @IBOutlet weak internal var emailTextField: UITextField!
    @IBOutlet weak internal var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func selectImageAction(_ sender: Any) {
        pickAnImageFromAlbum(self)
    }
    
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
        handleLoading(withLoading: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}

// MARK:- Select Image

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickAnImageFromAlbum(_ sender: Any) {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
}

// MARK:- Keyboard Handler Methods

extension SignUpViewController {
    
    @objc func keyboardWillShow(sender: NSNotification) {
        UIView.animate(withDuration: 0.5, animations: { self.view.frame.origin.y = -90 }, completion: nil)
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        UIView.animate(withDuration: 0.5, animations: { self.view.frame.origin.y = 0 }, completion: nil)
    }
    
}

// MARK:- Handler Methods

extension SignUpViewController {
    
    func handleCreateUser(authResult: AuthDataResult?, error: Error?) {
        guard let user = authResult?.user else {
            handleLoading(withLoading: false)
            let alert = UIAlertController(title: "Create User Error", message: error.debugDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.user = user
        guard let displayName = displayNameTextField.text else { return }
        
        if let image = profileImageView.image {
            FirebaseClient.uploadImage(image: image, user: self.user!, completionHandler: handleUploadImage(referenceURL:))
            return
        }
        FirebaseClient.createProfileChangeRequest(withDisplayName: displayName, photoURL: nil, completionHandler: handleProfileChangeRequest(error:))
    }
    
    func handleUploadImage(referenceURL: URL?) {
        guard let displayName = displayNameTextField.text else { return }
        guard let url = referenceURL else { return }
        FirebaseClient.createProfileChangeRequest(withDisplayName: displayName, photoURL: url, completionHandler: handleProfileChangeRequest(error:))
    }
    
    func handleProfileChangeRequest(error: Error?) {
        handleLoading(withLoading: false)
        guard error == nil else {
            let alert = UIAlertController(title: "Profile Change Failure", message: error!.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let alert = UIAlertController(title: "Profile Change Success", message: "User creation is complete", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            
            let userDictionary: [String: User] = ["User": self.user!]
            NotificationCenter.default.post(name: .signIn, object: nil, userInfo: userDictionary)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleLoading(withLoading isLoading: Bool) {
        self.navigationController?.view.isUserInteractionEnabled = !isLoading
        if isLoading { activityIndicator.startAnimating() }
        else { activityIndicator.stopAnimating() }
    }
    
}

// MARK:- Textfield Delegate Method

extension SignUpViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
