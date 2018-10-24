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
    static var ID: String {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            fatalError("Trying to register store without logging in first results in fatal error.")
        }
        
        return currentUserID
    }
    
    static func signIn(email: String, password: String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    static func register(email: String, password: String, completion: AuthDataResultCallback?){
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    static func isLoggedIn() -> Bool{
        return Auth.auth().currentUser != nil
    }
}
