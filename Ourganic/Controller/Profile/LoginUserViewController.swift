//
//  LoginUserViewController.swift
//  Ourganic
//
//  Created by Yoshua Elmaryono on 20/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit
import Firebase

class LoginUserViewController: UIViewController {
    //MARK: Outlets
    private weak var navigationBar: UINavigationBar!
    private weak var emailTextField: UITextField!
    private weak var passwordTextField: UITextField!
    private weak var submitButton: UIButton!

    //MARK: Action
    @objc private func loginUser(){
        submitButton.alpha = 0.5
        submitButton.isUserInteractionEnabled = false
        
        self.view.endEditing(true)
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        User.signIn(email: email, password: password) { (authResult, error) in
            if let error = error {
                self.handleLoginError(message: error.localizedDescription)
                return
            }
            
            self.closeLoginPage()
        }
    }
    @objc private func closeLoginPage(){
        self.dismiss(animated: true, completion: nil)
    }
    private func handleLoginError(message: String){
        submitButton.isUserInteractionEnabled = true
        styleButton(submitButton)
        
        let alertErrorController = UIAlertController(
            title: "Login Failed",
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
        
        setupNavigationBar()
        setupEmailTextField(previousElement: navigationBar)
        setupPasswordTextField(previousElement: emailTextField)
        setupSubmitButton(previousElement: passwordTextField)
    }
    private func setupNavigationBar(){
        let navbar = UINavigationBar()
        styleNavigationBar(navbar)
        
        view.addSubview(navbar)
        navbar.translatesAutoresizingMaskIntoConstraints = false
        navbar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navbar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        navbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navbar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let navItem = UINavigationItem(title: "Login")
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeLoginPage))
        
        navItem.rightBarButtonItem = backButton
        navbar.setItems([navItem], animated: false)
        
        self.navigationBar = navbar
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
    private func setupSubmitButton(previousElement: UIView){
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        styleButton(button)
        button.addTarget(self, action: #selector(loginUser), for: .touchUpInside)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: 20).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.submitButton = button
    }
}

extension LoginUserViewController: UITextFieldDelegate {
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
