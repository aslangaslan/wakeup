//
//  SignedViewController.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 5.04.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData

class LoggedInViewController: UIViewController {

    var user: User!
    var alarms: [AlarmEntity] = []
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<AlarmEntity>!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var profileImage: UIImageViewExtension!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBAction func signOutButtonAction(_ sender: Any) {
        FirebaseClient.signOut(completionHandler: handleSignOut(success:))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        debugPrint("User is :\(String(describing: self.user))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleUser()
    }
    
    func handleLoading(withLoading isLoading: Bool) {
        view.isUserInteractionEnabled = !isLoading
        if isLoading { activityIndicator.startAnimating() }
        else { activityIndicator.stopAnimating() }
    }
}

// Handler Methods

extension LoggedInViewController {
    
    func handleSignOut(success: Bool) {
        
        if success {
            // Post Sign-out Action
            NotificationCenter.default.post(Notification(name: .signOut))
            
            // Handle Logout View
            handleSignInViewAppear()
        } else {
            let alert = UIAlertController(title: "Sign Out Failure", message: "Unable to sign out session. Please tyr again later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleUser() {
        guard let displayName = self.user.displayName, let email = self.user.email else { return }
        displayNameLabel.text = displayName
        emailLabel.text = email
        handleLoading(withLoading: true)
        FirebaseClient.downloadImage(user: self.user) { (image) in
            self.handleLoading(withLoading: false)
            guard let image = image else { return }
            self.profileImage.image = image
        }
    }
    
    func handleSignInViewAppear() {

        // Instantiate Signed In View Controller
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signInViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController

        // Show Sign In View Controller
        navigationController?.setViewControllers([signInViewController], animated: true)
    }
}

// MARK:- Textfield Delegate Method

extension LoggedInViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
