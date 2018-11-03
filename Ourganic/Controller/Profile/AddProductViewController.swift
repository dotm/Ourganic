//
//  AddProductViewController.swift
//  Ourganic
//
//  Created by Yoshua Elmaryono on 28/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController {
    //MARK: Property
    private var categoryList: [CategoryModel] = []
    private let PICKER_TEXT_FIELD_TAG = 15135
    //MARK: Outlets
    private weak var navigationBar: UINavigationBar!
    private weak var productImageView: UIImageView!
    private weak var productImage: UIImage? = nil
    private weak var productNameTextField: UITextField!
    private weak var priceTextField: UITextField!
    private weak var unitQuantityView: UIView!
    private weak var minimalQuantityTextField: UITextField!
    private weak var unitMeasurementTextField: UITextField!
    private weak var locationTextField: UITextField!
    private weak var pickerTextField: UITextField!
    private weak var categoryPicker: UIPickerView!
    private var selectedCategory: String = ""
    private weak var descriptionTextField: UITextField!
    private weak var submitButton: UIButton!
    
    //MARK: Action
    @objc private func closeAddProductPage(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc private func addProduct(){
        submitButton.alpha = 0.5
        submitButton.isUserInteractionEnabled = false
        
        self.view.endEditing(true)
        
        guard let product = getProductData_fromForm() else {return}
        if let imageData = product.product_image?.jpegData(compressionQuality: 0.0) {
            let storeName = Store.name ?? ""
            let imagePath = "product_images/\(product.product_name + storeName + getCurrentDate_asString())"
            uploadImage(imagePath: imagePath, imageData: imageData) { (url, error) in
                guard let image_url = url?.absoluteString else {
                    self.handleAddProductError(message: error?.localizedDescription ?? "Error uploading image")
                    return
                }
                self.callAddProductAPI(product: product, image_url: image_url)
            }
        }else{
            callAddProductAPI(product: product, image_url: nil)
        }
        
    }
    private func callAddProductAPI(product: ProductData, image_url: String?){
        Store.add(product: product, image_url: image_url) { (error) in
            if let error = error {
                self.handleAddProductError(message: error.localizedDescription)
                return
            }
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (_) in
                alertUser(title: "Product Added", message: "Product has been successfully added to your store.")
            })
            self.closeAddProductPage()
        }
    }
    private func getProductData_fromForm() -> ProductData? {
        guard let name = productNameTextField.text, !name.isEmpty else {
            handleAddProductError(message: "Please insert product name.")
            return nil
        }
        let location = locationTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        guard let minimalQuantityText = minimalQuantityTextField.text, !minimalQuantityText.isEmpty else {
            handleAddProductError(message: "Please insert minimal quantity for product in \"min qty.\" field")
            return nil
        }
        guard let minimal_quantity = Double(minimalQuantityText), minimal_quantity > 0 else {
            handleAddProductError(message: "Invalid minimal quantity for product in \"min qty.\" field")
            return nil
        }
        guard let unit_measurement = unitMeasurementTextField.text, !unit_measurement.isEmpty else {
            handleAddProductError(message: "Please insert unit measurement of minimal quantity of the product")
            return nil
        }
        guard let priceText = priceTextField.text, !priceText.isEmpty else {
            handleAddProductError(message: "Please insert price for minimal quantity of product.")
            return nil
        }
        guard let price_per_unit = Double(priceText) else {
            handleAddProductError(message: "Invalid price per minimal quantity for product")
            return nil
        }
        
        let product: ProductData = (
            product_image: self.productImage,
            product_name: name,
            location: location,
            category: self.selectedCategory,
            description: description,
            minimal_quantity: minimal_quantity,
            unit_measurement: unit_measurement,
            price_per_unit: price_per_unit
        )
        return product
    }
    private func handleAddProductError(message: String){
        submitButton.isUserInteractionEnabled = true
        styleButton(submitButton)
        
        let alertErrorController = UIAlertController(
            title: "Add Product Failed",
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
        getCategoryList() { (result) in
            DispatchQueue.main.async {
                self.categoryList = result
                self.categoryPicker.reloadAllComponents()
            }
        }
        setupLayout()
    }
    //MARK: Layout
    private func setupLayout(){
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupProductImage(previousElement: navigationBar)
        setupProductNameTextField(previousElement: productImageView)
        setupPriceTextField(previousElement: productNameTextField)
        setupUnitQuantityView(previousElement: priceTextField)
        setupLocationTextField(previousElement: unitQuantityView)
        setupCategoryPicker(previousElement: locationTextField)
        setupDescriptionTextField(previousElement: pickerTextField)
        setupSubmitButton(previousElement: descriptionTextField)
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
        
        let navItem = UINavigationItem(title: "Add Product")
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeAddProductPage))
        
        navItem.rightBarButtonItem = backButton
        navbar.setItems([navItem], animated: false)
        
        self.navigationBar = navbar
    }
    private func setupProductImage(previousElement: UIView){
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        imageView.layer.borderWidth = 1.5
        imageView.image = UIImage(named: "addImage")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        let openImagePickerGesture = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(openImagePickerGesture)
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: previousElement.bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        self.productImageView = imageView
    }
    private func setupProductNameTextField(previousElement: UIView){
        let textField = UITextField()
        textField.delegate = self
        
        textField.placeholder = "Product Name"
        textField.autocapitalizationType = .words
        styleTextField(textField)
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: 10).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.productNameTextField = textField
    }
    private func setupPriceTextField(previousElement: UIView){
        let textField = UITextField()
        textField.delegate = self
        
        textField.placeholder = "Product Price"
        textField.keyboardType = .decimalPad
        styleTextField(textField)
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: 10).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.priceTextField = textField
    }
    private func setupUnitQuantityView(previousElement: UIView){
        let containerView = UIView()
        
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: 10).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        setupMinimalQuantityTextField(parentElement: containerView)
        setupUnitMeasurementTextField(parentElement: containerView)
        
        self.unitQuantityView = containerView
    }
    private func setupMinimalQuantityTextField(parentElement: UIView){
        let textField = UITextField()
        textField.delegate = self
        
        textField.placeholder = "500 (min qty.)"
        textField.keyboardType = .decimalPad
        styleTextField(textField)
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        parentElement.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leadingAnchor.constraint(equalTo: parentElement.leadingAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: parentElement.topAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: parentElement.widthAnchor, multiplier: 0.475).isActive = true
        textField.heightAnchor.constraint(equalTo: parentElement.heightAnchor).isActive = true
        
        self.minimalQuantityTextField = textField
    }
    private func setupUnitMeasurementTextField(parentElement: UIView){
        let textField = UITextField()
        textField.delegate = self
        
        textField.placeholder = "gram (unit)"
        textField.autocapitalizationType = .none
        styleTextField(textField)
        textField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        parentElement.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.trailingAnchor.constraint(equalTo: parentElement.trailingAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: parentElement.topAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: parentElement.widthAnchor, multiplier: 0.475).isActive = true
        textField.heightAnchor.constraint(equalTo: parentElement.heightAnchor).isActive = true
        
        self.unitMeasurementTextField = textField
    }
    private func setupLocationTextField(previousElement: UIView){
        let textField = UITextField()
        textField.delegate = self
        
        textField.placeholder = "Location"
        textField.autocapitalizationType = .words
        styleTextField(textField)
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: 10).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.locationTextField = textField
    }
    private func setupCategoryPicker(previousElement: UIView){
        let textField = UITextField()
        textField.delegate = self
        
        textField.placeholder = "Product Category"
        textField.autocapitalizationType = .words
        styleTextField(textField)
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: 10).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        textField.tag = PICKER_TEXT_FIELD_TAG
        self.pickerTextField = textField
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        self.categoryPicker = picker
        textField.inputView = picker
    }
    private func setupDescriptionTextField(previousElement: UIView){
        let textField = UITextField()
        textField.delegate = self
        
        textField.placeholder = "Product Description"
        textField.autocapitalizationType = .sentences
        styleTextField(textField)
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: 10).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.descriptionTextField = textField
    }
    private func setupSubmitButton(previousElement: UIView){
        let button = UIButton()
        button.setTitle("Add Product to Your Store", for: .normal)
        styleButton(button)
        button.addTarget(self, action: #selector(addProduct), for: .touchUpInside)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: 20).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.submitButton = button
    }

}

extension AddProductViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let categoryName = self.categoryList[row].name
        return categoryName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCategory = self.categoryList[row]
        self.selectedCategory = selectedCategory.code
        
        let categoryName = selectedCategory.name
        pickerTextField.text = categoryName
    }
}
extension AddProductViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categoryList.count
    }
}

extension AddProductViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == PICKER_TEXT_FIELD_TAG {
            let selectedCategory = self.categoryList[0]
            self.selectedCategory = selectedCategory.code
            
            let first_categoryName = selectedCategory.name
            textField.text = first_categoryName
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

extension AddProductViewController {
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
}
extension AddProductViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            productImage = pickedImage
            productImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
extension AddProductViewController: UINavigationControllerDelegate {
    
}
