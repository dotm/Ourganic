//
//  RegisterUserViewController.swift
//  Ourganic
//
//  Created by Yoshua Elmaryono on 16/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class RegisterUserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()
//        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
//            self.dismiss(animated: true, completion: nil)
//        }
    }
    
    private func setupLayout(){
        let emailTextField = UITextField()
        let nameTextField = UITextField()
        let passwordTextField = UITextField()
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
