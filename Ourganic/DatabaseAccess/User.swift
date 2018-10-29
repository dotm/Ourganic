//
//  User.swift
//  Ourganic
//
//  Created by Yoshua Elmaryono on 24/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import Foundation
import Firebase

enum User {
    static var ID: String? {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No user logged in.")
            return nil
        }
        
        return currentUserID
    }
    
    static func signIn(email: String, password: String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error signing in:", error)
            }else{
                Store.initialize()
            }
            
            completion?(result, error)
        }
    }
    static func register(email: String, password: String, completion: AuthDataResultCallback?){
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    static func isLoggedIn() -> Bool{
        return Auth.auth().currentUser != nil
    }
}
