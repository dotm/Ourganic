//
//  ProfileViewController.swift
//  Ourganic
//
//  Created by Yoshua Elmaryono on 16/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    var userHandle: AuthStateDidChangeListenerHandle!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        goTo_addStorePage()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = auth.currentUser {
                print("Logged In User:", user.uid, user.email!, user.displayName!, separator: "\n", terminator: "\n\n")
            }else{
                print("No user is currently logged in.")
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(userHandle!)
    }
    
    //MARK: User Management
    private func logoutUser(){
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error logging out:", error)
        }
    }
    private func goTo_loginPage(){
        present(LoginUserViewController(), animated: true, completion: nil)
    }
    private func goTo_registrationPage(){
        present(RegisterUserViewController(), animated: true, completion: nil)
    }

    //MARK: Store Management
    private func goTo_addStorePage(){
        ensureThat_userIsLoggedIn(then: (
            present(AddStoreViewController(), animated: true, completion: nil)
        ))
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
