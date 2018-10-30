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
    private weak var navigationBar: UINavigationBar!
    private weak var userImageView: UIImageView!
    private weak var userImage: UIImage? = nil
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
        
        let imageData: Data? = userImage?.jpegData(compressionQuality: 1.0)
        if let imageData = imageData {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let currentDate: String = formatter.string(from: Date())
            let imagePath = "user_images/\(email + fullname + currentDate).jpg"
            
            let storageRef = Storage.storage().reference()
            let spaceRef = storageRef.child(imagePath)
            let uploadTask = spaceRef.putData(imageData, metadata: nil) { (metadata, error) in
                guard let _ = metadata else {
                    print("Error uploading user image:", error!)
                    return
                }
                spaceRef.downloadURL(completion: { (url, error) in
                    guard let image_url = url else { return }
                    self.callRegistrationAPI(email: email, password: password, fullname: fullname, image_url: image_url)
                })
            }
            uploadTask.enqueue()
        }else{
            callRegistrationAPI(email: email, password: password, fullname: fullname, image_url: nil)
        }
    }
    private func callRegistrationAPI(email: String, password: String, fullname: String, image_url: URL?){
        User.register(email: email, password: password) { (authResult, error) in
            if let error = error {
                self.handleRegistrationError(message: error.localizedDescription)
                return
            }
            
            guard let user = authResult?.user else {return}
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = fullname
            if let image_url = image_url {
                changeRequest.photoURL = image_url
            }
            changeRequest.commitChanges(completion: { (err) in
                if let error = err {
                    self.handleRegistrationError(message: "Error setting user's name: \(error.localizedDescription)")
                    return
                }
                
                self.closeRegistrationPage()
            })
        }
    }
    @objc private func closeRegistrationPage(){
        self.dismiss(animated: true, completion: nil)
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
    override func viewDidLayoutSubviews() {
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.clipsToBounds = true
        userImageView.layer.borderColor = UIColor.black.cgColor
        userImageView.layer.borderWidth = CGFloat(1.0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()
    }
    //MARK: Layout
    private func setupLayout(){
        view.backgroundColor = .white

        setupNavigationBar()
        setupUserImage(previousElement: navigationBar)
        setupEmailTextField(previousElement: userImageView)
        setupNameTextField(previousElement: emailTextField)
        setupPasswordTextField(previousElement: nameTextField)
        setupRegisterButton(previousElement: passwordTextField)
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
        
        let navItem = UINavigationItem(title: "Register")
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeRegistrationPage))
        
        navItem.rightBarButtonItem = backButton
        navbar.setItems([navItem], animated: false)
        
        self.navigationBar = navbar
    }
    @objc private func openImagePicker(){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have perission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    private func setupUserImage(previousElement: UIView){
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultUserImage")
        
        let openImagePickerGesture = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(openImagePickerGesture)
        
        view.addSubview(imageView)
        let imageLength = CGFloat(100)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageLength).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageLength).isActive = true
        
        self.userImageView = imageView
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

extension RegisterUserViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImage = pickedImage
            userImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
extension RegisterUserViewController: UINavigationControllerDelegate {
    
}
