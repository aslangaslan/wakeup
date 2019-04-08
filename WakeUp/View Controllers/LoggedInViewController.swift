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
import Reachability

class LoggedInViewController: UIViewController {

    var user: User!
    var alarms: [AlarmEntity] = []
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<AlarmEntity>!
    var reachability: Reachability!
    
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
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reachability = Reachability()!
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
        
        if reachability.isReachable {
            handleLoading(withLoading: true)
            FirebaseClient.downloadImage(user: self.user) { (image, error) in
                self.handleLoading(withLoading: false)
                guard let image = image else {
                    let alert = UIAlertController(title: "Get Profile Image Failed", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil) }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                self.profileImage.image = image
            }
        }
        else {
            let alert = UIAlertController(title: "Connection Failure", message: "There is no internet connection.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true, completion: nil)
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
