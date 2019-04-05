//
//  FirebaseClient.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 5.04.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class FirebaseClient {
    
    static func createUser(withEmail email: String, password: String, completionHandler: @escaping (AuthDataResult?, Error?) -> Void) {
        Firebase.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let authResult = authResult {
                DispatchQueue.main.async {
                    completionHandler(authResult, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    static func createProfileChangeRequest(withDisplayName displayName: String, completionHandler: @escaping (Error?) -> Void) {
        
        let changeRequest = Firebase.Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.photoURL =  URL(string: "https://www.google.com")
        changeRequest?.commitChanges(completion: { (error) in
            guard let error = error else {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(error)
            }
        })
    }
    
    static func signIn(withEmail email: String, password: String, completionHandler: @escaping (AuthDataResult?, Error?) -> Void) {
        Firebase.Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            guard let authResult = authResult else {
                DispatchQueue.main.async {
                        completionHandler(nil,error)
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(authResult,nil)
            }
        }
    }
    
    static func isUserSignedIn(completionHandler: @escaping (User?) -> Void) {
        Firebase.Auth.auth().addStateDidChangeListener() { auth, user in
            guard let user = user else {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(user)
            }
        }
    }
    
    static func signOut(completionHandler: @escaping (Bool) -> Void) {
        do {
            try Firebase.Auth.auth().signOut()
            DispatchQueue.main.async {
                completionHandler(true)
            }
        } catch {
            DispatchQueue.main.async {
                completionHandler(false)
            }
        }
    }
}
