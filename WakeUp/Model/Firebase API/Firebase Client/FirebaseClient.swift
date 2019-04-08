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
import FirebaseStorage
import FirebaseDatabase

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
    
    static func createProfileChangeRequest(withDisplayName displayName: String, photoURL: URL?, completionHandler: @escaping (Error?) -> Void) {
        let changeRequest = Firebase.Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.photoURL =  photoURL
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
    
    static func uploadImage(image: UIImage, user: User, completionHandler: @escaping (URL?) -> Void) {
        let uuid: String = user.uid
        let reference = uuid + "-profile.jpg"
        let storageRef = Storage.storage().reference().child(reference)
        if let uploadData = image.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    completionHandler(nil)
                    return
                }
                let _ = metadata.size
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        completionHandler(nil)
                        return
                    }
                    completionHandler(downloadURL)
                }
            }
        }
    }
    
    static func downloadImage(user: User, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let reference = user.uid + "-profile.jpg"
        let storageRef = Storage.storage().reference().child(reference)
        
        // Download in memory with a maximum allowed size of 2MB (1 * 1024 * 1024 bytes)
        storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            } else {
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    completionHandler(image, nil)
                }
            }
        }
    }
}
