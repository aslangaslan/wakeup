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
    
    @IBOutlet weak var displayNameTextField: UILabel!
    @IBOutlet weak var emailTextField: UILabel!
    
    @IBAction func backupButtonAction(_ sender: Any) {

    }
    
    @IBAction func signOutButtonAction(_ sender: Any) {
        FirebaseClient.signOut(completionHandler: handleSignOut(success:))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleNavigationBarHidden()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirebaseClient.isUserSignedIn(completionHandler: handleIsUserLoggedIn(user:))
        setupFetchedResultsController()
    }
    
    func handleNavigationBarHidden() {
        navigationController?.navigationBar.isHidden = true
    }
}

// Core Data Methods

extension LoggedInViewController: NSFetchedResultsControllerDelegate {
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<AlarmEntity> = AlarmEntity.fetchRequest()
        let predicate = NSPredicate(format: "userUID == %@", user.uid)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: dataController.viewContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: "\(String(describing: user))_alarms")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            handlePerformFetch()
        } catch {
            debugPrint("Alarm entity could not be read. Core data problem.")
        }
    }
    
    func handlePerformFetch() {
    
        guard let alarmEntities = fetchedResultsController.fetchedObjects else { return }
        debugPrint("Alarm entities object count \(alarmEntities.count)")
    }
}

// Handler Methods

extension LoggedInViewController {
    
    func handleSignOut(success: Bool) {
        if success {
            handleSignInViewAppear()
        } else {
            let alert = UIAlertController(title: "Sign Out Failure", message: "Unable to sign out session. Please tyr again later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleIsUserLoggedIn(user: User?) {
        guard let displayName = user?.displayName, let email = user?.email else {
            handleSignInViewAppear()
            return
        }
        displayNameTextField.text = displayName
        emailTextField.text = email
    }
    
    func handleSignInViewAppear() {

        // Instantiate Signed In View Controller
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signInViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController

        // Show Sign In View Controller
        navigationController?.setViewControllers([signInViewController], animated: true)
    }
}
