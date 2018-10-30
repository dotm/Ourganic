//
//  AddStoreViewController.swift
//  Ourganic
//
//  Created by Yoshua Elmaryono on 23/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class AddStoreViewController: UIViewController {
    //MARK: Outlets
    private weak var navigationBar: UINavigationBar!
    private weak var nameTextField: UITextField!
    private weak var addressTextField: UITextField!
    private weak var phoneTextField: UITextField!
    private weak var submitButton: UIButton!
    
    //MARK: Action
    @objc private func closeAddStorePage(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc private func registerStore(){
        submitButton.alpha = 0.5
        submitButton.isUserInteractionEnabled = false
        
        self.view.endEditing(true)
        
        guard let name = nameTextField.text else {
            handleRegisterStoreError(message: "Please insert store name.")
            return
        }
        let address = addressTextField.text
        let phone = phoneTextField.text
        let image: UIImage? = nil //TODO: implement this
        let storeData = (name: name, address: address, phone: phone, image: image)
        Store.register(store: storeData) { (error) in
            if let error = error {
                self.handleRegisterStoreError(message: error.localizedDescription)
                return
            }
            
            self.alertRegistrationSuccess()
            self.closeAddStorePage()
        }
    }
    private func alertRegistrationSuccess(){
        let alertController = UIAlertController(
            title: "Store Registration Successful",
            message: "You can now add products to your store.",
            preferredStyle: .alert
        )
        let dismiss = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        alertController.addAction(dismiss)
        self.present(alertController, animated: true, completion: nil)
    }
    private func handleRegisterStoreError(message: String){
        submitButton.isUserInteractionEnabled = true
        styleButton(submitButton)
        
        let alertErrorController = UIAlertController(
            title: "Store Registration Failed",
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
    private func setupLayout(){
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupNameTextField(previousElement: navigationBar)
        setupAddressTextField(previousElement: nameTextField)
        setupPhoneTextField(previousElement: addressTextField)
        setupSubmitButton(previousElement: phoneTextField)
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
        
        let navItem = UINavigationItem(title: "Register Your Store")
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeAddStorePage))
        
        navItem.rightBarButtonItem = backButton
        navbar.setItems([navItem], animated: false)
        
        self.navigationBar = navbar
    }
    private func setupNameTextField(previousElement: UIView){
        let textField = UITextField()
        textField.delegate = self
        
        textField.placeholder = "Store Name"
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
    private func setupAddressTextField(previousElement: UIView){
        let textField = UITextField()
        textField.delegate = self
        
        textField.placeholder = "Store Address"
        textField.autocapitalizationType = .words
        styleTextField(textField)
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: 10).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addressTextField = textField
    }
    private func setupPhoneTextField(previousElement: UIView){
        let textField = UITextField()
        textField.delegate = self
        
        textField.placeholder = "Store Phone Number"
        textField.keyboardType = .phonePad
        styleTextField(textField)
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: 10).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.phoneTextField = textField
    }
    private func setupSubmitButton(previousElement: UIView){
        let button = UIButton()
        button.setTitle("Register Store", for: .normal)
        styleButton(button)
        button.addTarget(self, action: #selector(registerStore), for: .touchUpInside)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: 20).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.submitButton = button
    }

}


extension AddStoreViewController: UITextFieldDelegate {
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
