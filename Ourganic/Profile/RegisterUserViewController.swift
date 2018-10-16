//
//  RegisterUserViewController.swift
//  Ourganic
//
//  Created by Yoshua Elmaryono on 16/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class RegisterUserViewController: UIViewController {
    private weak var emailTextField: UITextField!
    private weak var nameTextField: UITextField!
    private weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()
//        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
//            self.dismiss(animated: true, completion: nil)
//        }
    }
    
    private func setupLayout(){
        view.backgroundColor = .white
        
        let pageTitle = setupPageTitle()
        let emailTextField = setupEmailTextField(parent: pageTitle)
        let nameTextField = setupNameTextField(parent: emailTextField)
        let passwordTextField = setupPasswordTextField(parent: nameTextField)
        setupRegisterButton(parent: passwordTextField)
    }
    private func setupPageTitle() -> UIView {
        let pageTitle = UILabel()
        pageTitle.text = "Register"
        pageTitle.textAlignment = .center
        styleTitleLabel(pageTitle)
        
        let parent = view!
        parent.addSubview(pageTitle)
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        pageTitle.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        pageTitle.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        pageTitle.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        pageTitle.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        return pageTitle
    }
    private func setupEmailTextField(parent: UIView) -> UIView {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        styleTextField(textField)
        
        parent.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 10).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.emailTextField = textField
        return textField
    }
    private func setupNameTextField(parent: UIView) -> UIView {
        let textField = UITextField()
        textField.placeholder = "Full Name"
        styleTextField(textField)
        
        parent.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 10).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.nameTextField = textField
        return textField
    }
    private func setupPasswordTextField(parent: UIView) -> UIView {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        styleTextField(textField)
        
        parent.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 10).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.passwordTextField = textField
        return textField
    }
    private func setupRegisterButton(parent: UIView) -> UIView {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        styleButton(button)
        
        parent.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 20).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
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
