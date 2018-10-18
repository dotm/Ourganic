//
//  RegisterUserViewController.swift
//  Ourganic
//
//  Created by Yoshua Elmaryono on 16/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit
import Firebase

class RegisterUserViewController: UIViewController {
    //MARK: Outlets
    private weak var pageTitle: UILabel!
    private weak var emailTextField: UITextField!
    private weak var nameTextField: UITextField!
    private weak var passwordTextField: UITextField!
    private weak var registerButton: UIButton!

    //MARK: Action
    @objc private func registerUser(){
        registerButton.alpha = 0.5
        registerButton.isUserInteractionEnabled = false
        
        self.view.endEditing(true)
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let fullname = nameTextField.text!

        Auth.auth().createUser(withEmail: email, password: password) { (authResult, errorOptional) in
            if let error = errorOptional {
                self.handleRegistrationError(message: error.localizedDescription)
                return
            }
            
            guard let user = authResult?.user else {return}
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = fullname
            changeRequest.commitChanges(completion: { (err) in
                if let error = err {
                    self.handleRegistrationError(message: "Error setting user's name: \(error.localizedDescription)")
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    private func handleRegistrationError(message: String){
        registerButton.isUserInteractionEnabled = true
        styleButton(registerButton)
        
        let alertErrorController = UIAlertController(
            title: "Registration Failed",
            message: message,
            preferredStyle: .alert
        )
        let dismiss = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        alertErrorController.addAction(dismiss)
        self.present(alertErrorController, animated: true, completion: nil)
    }
    
    //MARK: Lifecycle Hook
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()
    }
    //MARK: Layout
    private func setupLayout(){
        view.backgroundColor = .white
        
        setupPageTitle()
        setupEmailTextField(previousElement: pageTitle)
        setupNameTextField(previousElement: emailTextField)
        setupPasswordTextField(previousElement: nameTextField)
        setupRegisterButton(previousElement: passwordTextField)
    }
    private func setupPageTitle(){
        let pageTitle = UILabel()
        pageTitle.text = "Register"
        pageTitle.textAlignment = .center
        pageTitle.isUserInteractionEnabled = true
        styleTitleLabel(pageTitle)
        
        view.addSubview(pageTitle)
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        pageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        pageTitle.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        pageTitle.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.pageTitle = pageTitle
    }
    private func setupEmailTextField(previousElement: UIView){
        let textField = UITextField()
        textField.delegate = self
        
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        styleTextField(textField)
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: 10).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.emailTextField = textField
    }
    private func setupNameTextField(previousElement: UIView){
        let textField = UITextField()
        textField.delegate = self
        
        textField.placeholder = "Full Name"
        textField.autocapitalizationType = .words
        styleTextField(textField)
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: 10).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.nameTextField = textField
    }
    private func setupPasswordTextField(previousElement: UIView){
        let textField = UITextField()
        textField.delegate = self
        
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        styleTextField(textField)
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: 10).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.passwordTextField = textField
    }
    private func setupRegisterButton(previousElement: UIView){
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        styleButton(button)
        button.addTarget(self, action: #selector(registerUser), for: .touchUpInside)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: 20).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.registerButton = button
    }
}

extension RegisterUserViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
