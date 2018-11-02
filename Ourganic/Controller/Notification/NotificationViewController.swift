//
//  NotificationViewController.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 30/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

typealias ProductTableViewCellData = (
    product_name: String,
    product_image_url: String,
    order_date: String,
    delivery_method: String,
    status_text1: String,
    status_text2: String
)

let mock: ProductTableViewCellData = (
    product_name: "Koin Organik",
    product_image_url: "https://firebasestorage.googleapis.com/v0/b/ourganic-d931d.appspot.com/o/product_images%2FKoin%20OrganikPT.%20Joe%20Sejahtera2018-10-31%2017:20:05?alt=media&token=ace23471-094a-4ba6-bfb6-230c5ab90f18",
    order_date: "5 Oct 2018 10:07",
    delivery_method: "JNE REG",
    status_text1: "Waiting Payment",
    status_text2: "Rp. 20.000"
)

class NotificationViewController: UIViewController {
    //MARK: Outlets
    private weak var segmentedControl: UISegmentedControl!
    private weak var productTableView: UITableView!

    //MARK: Properties
    private let PRODUCT_CELL = "Product cell"
    private var productsData: [ProductTableViewCellData] = [mock] {
        didSet {
            reloadTable()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLayout()
    }
    private func setupLayout(){
        setupSegmentedControl()
        setupProductTable(previousElement: segmentedControl)
    }
    private func setupSegmentedControl(){
        let control = UISegmentedControl()
        control.insertSegment(withTitle: "On My Cart", at: 0, animated: false)
        control.insertSegment(withTitle: "Selling", at: 1, animated: false)
        control.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        control.tintColor = defaultTitleTextColor
        
        view.addSubview(control)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        control.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        control.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        control.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        
        self.segmentedControl = control
    }
    @objc private func segmentedControlChanged(_ control: UISegmentedControl){
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            productsData = getProducts_onMyCart()
        case 1:
            productsData = getProducts_currentlySelling()
        default:
            productsData = []
        }
    }
    private func getProducts_onMyCart() -> [ProductTableViewCellData]{
        return []
    }
    private func getProducts_currentlySelling() -> [ProductTableViewCellData]{
        return []
    }
    private func setupProductTable(previousElement: UIView){
        let tableView = UITableView()
        tableView.tableFooterView = UIView() //remove empty cells in table view
        tableView.register(NotificationProductTableViewCell.self, forCellReuseIdentifier: PRODUCT_CELL)
        tableView.rowHeight = CGFloat(100)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: 10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.productTableView = tableView
    }
    
    //MARK: Helpers
    private func reloadTable(){
        productTableView.reloadSections(IndexSet(0..<1), with: .automatic)
    }
}

extension NotificationViewController: UITableViewDelegate {
    
}
extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let productData = productsData[index]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PRODUCT_CELL) as! NotificationProductTableViewCell
        cell.productNameLabel.text = productData.product_name
        
        var data: Data? = nil
        let url = URL(string: productData.product_image_url)
        DispatchQueue.global().async {
            if let url = url {
                data = try? Data(contentsOf: url)
            }
            DispatchQueue.main.async {
                if let data = data, let productImage = UIImage(data: data) {
                    cell.productImageView.image = productImage
                }
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch segmentedControl.selectedSegmentIndex {
        case 0: return "On my cart"
        case 1: return "Products ordered"
        default: return "Please select one option above"
        }
    }
}
