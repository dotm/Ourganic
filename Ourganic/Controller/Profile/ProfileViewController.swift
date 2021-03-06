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
    private weak var navigationBar: UINavigationBar!
    private weak var userImageView: UIImageView!
    private weak var usernameLabel: UILabel!
    private weak var storeNameLabel: UILabel!
    private weak var leftLink: UILabel!
    private weak var rightLink: UILabel!
    private var userImage: UIImage?
    private weak var userProfileView: UIView!
    private weak var productCollectionView: UICollectionView!
    private var products: [Product]? = nil {
        didSet {
            self.productCollectionView.reloadData()
        }
    }
    private let CELL_ID = "My products cell"
    private weak var addProductButton: UIButton!
    fileprivate var userHandle: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = auth.currentUser {
                print("Logged In User:", user.uid, user.email!, user.displayName ?? "No display name", user.photoURL ?? "No photo", separator: "\n", terminator: "\n\n")
                self.setupLayout_toLoggedIn(username: user.displayName ?? "Username not set yet", userImageURL: user.photoURL)
            }else{
                print("No user is currently logged in.")
                self.setupLayout_toLoggedOut()
            }
            self.setupLinks()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(userHandle!)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.clipsToBounds = true
        userImageView.layer.borderColor = UIColor.black.cgColor
        userImageView.layer.borderWidth = CGFloat(1.0)
    }
    
    //MARK: User Management
    @objc private func logoutUser(){
        User.signOut {
            self.userImage = nil
        }
    }
    @objc private func goTo_loginPage(){
        present(LoginUserViewController(), animated: true, completion: nil)
    }
    @objc private func goTo_registrationPage(){
        present(RegisterUserViewController(), animated: true, completion: nil)
    }
    @objc private func goTo_editProfilePage(){
        alert_featureToBeImplemented()
    }
    
    //MARK: Store Management
    @objc private func addProductButtonPressed(){
        ensureThat_userIsLoggedIn {
            if let _ = Store.ID { //if user has a store registered
                goTo_addProductPage()
            }else{
                alertUser_toRegisterStoreFirst({ (_) in
                    Timer.scheduledTimer(withTimeInterval: 0.33, repeats: false, block: { (_) in
                        if Store.ID == nil { //check if store really isn't registered
                            self.goTo_addStorePage()
                        }
                    })
                })
            }
        }
    }
    private func goTo_addStorePage(){
        ensureThat_userIsLoggedIn(then: (
            present(AddStoreViewController(), animated: true, completion: nil)
        ))
    }
    private func goTo_addProductPage(){
        ensureThat_userHasRegisteredStore(then: present(AddProductViewController(), animated: true, completion: nil))
    }
    
    //MARK: Layout
    private let defaultUserName = "Guest"
    private let defaultStoreName = "Please login first"
    private let defaultUserImage_string = "defaultUserImage"
    private func setupLayout_toLoggedOut(){
        self.usernameLabel.text = defaultUserName
        self.storeNameLabel.text = defaultStoreName
        self.userImageView.image = UIImage(named: defaultUserImage_string)
        self.products = []
    }
    private func setupLayout_toLoggedIn(username: String, userImageURL: URL?){
        self.usernameLabel.text = username
        loadUserImage(from: userImageURL)
        
        //To fix bug: store name not displayed some of the time when user login
        if let storeName = Store.name, let myStoreID = Store.ID {
            self.storeNameLabel.text = storeName
            loadProductList(myStoreID: myStoreID)
        }else{
            self.storeNameLabel.text = "Loading your store data"
            products = []
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
                self.storeNameLabel.text = Store.name ?? "No store registered"
                self.loadProductList(myStoreID: Store.ID)
            }
        }
    }
    private func loadProductList(myStoreID: String?){
        guard let myStoreID = myStoreID else {return}
        getProductList(store_id: myStoreID) { (products, error) in
            if let error = error {
                print("Error getting product list:", error)
                return
            }
            
            self.products = products
        }
    }
    private func loadUserImage(from url: URL?){
        self.userImageView.kf.setImage(with: url, placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)

    }
    private func setupLayout(){
        setupNavigationBar()
        setupAddProductButton()
        setupUserView(previousElement: navigationBar)
        setupProductCollectionView(previousElement: userProfileView, bottomElement: addProductButton)
    }
    private func setupNavigationBar(){
        let navbar = UINavigationBar()
        styleNavigationBar(navbar)
        
        view.addSubview(navbar)
        navbar.translatesAutoresizingMaskIntoConstraints = false
        navbar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navbar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        navbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navbar.heightAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        
        let navItem = UINavigationItem(title: "Profile")
        navbar.setItems([navItem], animated: false)
        
        self.navigationBar = navbar
    }
    private func setupProductCollectionView(previousElement: UIView, bottomElement: UIView){
        let spacing = CGFloat(10)
        let margins = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        let layout = ColumnFlowLayout(cellsPerRow: 3, minimumInteritemSpacing: spacing, minimumLineSpacing: spacing, sectionInset: margins)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(MyProductCollectionViewCell.self, forCellWithReuseIdentifier: CELL_ID)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: previousElement.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: previousElement.leadingAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomElement.topAnchor, constant: -10).isActive = true
        
        self.productCollectionView = collectionView
    }
    private func setupUserView(previousElement: UIView){
        let userView = UIView()
        
        view.addSubview(userView)
        userView.translatesAutoresizingMaskIntoConstraints = false
        userView.topAnchor.constraint(equalTo: previousElement.bottomAnchor).isActive = true
        userView.leadingAnchor.constraint(equalTo: previousElement.leadingAnchor).isActive = true
        userView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        userView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        setupUserPhoto(parent: userView)
        setupUserLabels(parent: userView, elementOnTheLeft: userImageView)
        
        self.userProfileView = userView
    }
    private func setupUserPhoto(parent: UIView){
        let imageView = UIImageView()
        let defaultImage = UIImage(named: defaultUserImage_string)
        imageView.image = defaultImage
        
        parent.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 10).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
        self.userImageView = imageView
    }
    private func setupUserLabels(parent: UIView, elementOnTheLeft: UIView){
        let usernameLabel = UILabel()
        usernameLabel.text = defaultUserName
        self.usernameLabel = usernameLabel
        
        let storeNameLabel = UILabel()
        storeNameLabel.text = defaultStoreName
        self.storeNameLabel = storeNameLabel
        
        let links = linksStackView()
        
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, storeNameLabel, links])
        stackView.axis =  .vertical
        stackView.spacing = CGFloat(0.3)
        stackView.alignment = .leading
        
        parent.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: elementOnTheLeft.trailingAnchor, constant: 20).isActive = true
        stackView.widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: 0.5).isActive = true
    }
    private func linksStackView() -> UIStackView{
        let leftLink = UILabel()
        styleLink(leftLink)
        self.leftLink = leftLink
        
        let separator = UILabel()
        separator.text = "|"
        
        let rightLink = UILabel()
        styleLink(rightLink)
        self.rightLink = rightLink
        
        setupLinks()
        
        let stackView = UIStackView(arrangedSubviews: [leftLink, separator, rightLink])
        stackView.axis = .horizontal
        stackView.spacing = CGFloat(20)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
    private func setupLinks(){
        let registerGesture = UITapGestureRecognizer(target: self, action: #selector(goTo_registrationPage))
        let loginGesture = UITapGestureRecognizer(target: self, action: #selector(goTo_loginPage))
        let logoutGesture = UITapGestureRecognizer(target: self, action: #selector(logoutUser))
        let editProfileGesture = UITapGestureRecognizer(target: self, action: #selector(goTo_editProfilePage))
        
        leftLink.isUserInteractionEnabled = true
        rightLink.isUserInteractionEnabled = true
        
        if User.isLoggedIn() {
            leftLink.text = "Edit Profile"
            leftLink.addGestureRecognizer(editProfileGesture)
            
            rightLink.text = "Log out"
            rightLink.addGestureRecognizer(logoutGesture)
        }else{
            leftLink.text = "Register"
            leftLink.addGestureRecognizer(registerGesture)
            
            rightLink.text = "Log in"
            rightLink.addGestureRecognizer(loginGesture)
        }
    }
    private func setupAddProductButton(){
        let button = UIButton()
        button.setTitle("Add Product to Your Store", for: .normal)
        styleButton(button)
        button.addTarget(self, action: #selector(addProductButtonPressed), for: .touchUpInside)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.addProductButton = button
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! MyProductCollectionViewCell
        guard let product: Product = products?[indexPath.row] else {
            return cell
        }
        
        cell.productName = product.product_name
        cell.productImageUrl = product.image_url
        
        return cell
    }
    
}

extension ProfileViewController: UICollectionViewDelegate {
    
}
