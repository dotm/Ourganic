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

class NotificationViewController: UIViewController {
    //MARK: Outlets
    private weak var segmentedControl: UISegmentedControl!
    private weak var productTableView: UITableView!
    
    //MARK: Properties
    private let PRODUCT_CELL = "Product cell"
    private var orderModels:[OrderModel] = []
    private var productsData: [ProductTableViewCellData] = [] {
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
        self.segmentedControl.selectedSegmentIndex = 0
        segmentedControlChanged(self.segmentedControl)
    }
    @objc private func segmentedControlChanged(_ control: UISegmentedControl){
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            getProducts_onMyCart() { (myCartRes) in
                self.productsData = myCartRes
            }
        case 1:
            getProducts_currentlySelling() { (mySelling) in
                self.productsData = mySelling
            }
        default:
            productsData = []
        }
    }
    
    private func getProducts_onMyCart(completion callback: (([ProductTableViewCellData]) -> Void)?){
        var list:[ProductTableViewCellData] = []
        getOrderList(userId: User.ID!) { (result) in
            DispatchQueue.main.async {
                self.orderModels.removeAll()
                self.orderModels = result
                for order:OrderModel in result {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
                    let orderDate = dateFormatter.string(from: order.createdDate)
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .currency
                    numberFormatter.locale = Locale(identifier: "id-ID")
                    var text2 = "-"
                    
                    getProductByDocId(documentId: order.productId) { (prodRes, error) in
                        DispatchQueue.main.async {
                            order.product = (
                                product_id: prodRes.product_id,
                                store_id: prodRes.store_id,
                                store_name: prodRes.store_name,
                                product_name: prodRes.product_name,
                                location: prodRes.location,
                                category: prodRes.category,
                                description: prodRes.description,
                                minimal_quantity: prodRes.minimal_quantity,
                                unit_measurement: prodRes.unit_measurement,
                                price_per_unit: prodRes.price_per_unit,
                                image_url: prodRes.image_url
                            )
                            var statusList:[StatusModel] = []
                            getStatusList(orderDocId: order.id!) { (statusRes) in
                                DispatchQueue.main.async {
                                    order.statusHistory = statusRes
                                    
                                    if statusList.isEmpty {
                                        statusList.append(statusCons[0])
                                    }
                                    
                                    if (order.statusHistory.isEmpty) {
                                        order.statusHistory.append(statusCons[0])
                                    }
                                    
                                    if order.statusHistory[0].code == 2 || order.statusHistory[0].code == 3 {
                                        text2 = order.statusHistory[0].buyerDesc
                                    } else {
                                        if order.statusHistory[0].createdDate != nil {
                                            text2 = dateFormatter.string(from: ((order.statusHistory[0].createdDate!)))
                                        }
                                    }
                                    
                                    list.append(ProductTableViewCellData(
                                        product_name: order.product?.product_name ?? "Unkonwn",
                                        product_image_url: order.product?.image_url ?? "",
                                        order_date: orderDate,
                                        delivery_method: order.deliveryMethod,
                                        status_text1: order.statusHistory[0].buyerDesc ,
                                        status_text2: text2))
                                    
                                    callback!(list)
                                }
                            }
                        }
                    }
                }
                callback!(list)
            }
        }
    }
    
    private func getProducts_currentlySelling(completion callback: (([ProductTableViewCellData]) -> Void)?) {
        var list:[ProductTableViewCellData] = []
        getSellingList(userId: User.ID!) { (result) in
            DispatchQueue.main.async {
                self.orderModels.removeAll()
                self.orderModels = result
                for order:OrderModel in result {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
                    let orderDate = dateFormatter.string(from: order.createdDate)
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .currency
                    numberFormatter.locale = Locale(identifier: "id-ID")
                    
                    getProductByDocId(documentId: order.productId) { (prodRes, error) in
                        DispatchQueue.main.async {
                            order.product = (
                                product_id: prodRes.product_id,
                                store_id: prodRes.store_id,
                                store_name: prodRes.store_name,
                                product_name: prodRes.product_name,
                                location: prodRes.location,
                                category: prodRes.category,
                                description: prodRes.description,
                                minimal_quantity: prodRes.minimal_quantity,
                                unit_measurement: prodRes.unit_measurement,
                                price_per_unit: prodRes.price_per_unit,
                                image_url: prodRes.image_url
                            )
                            
                            getStatusList(orderDocId: order.id!) { (statusRes) in
                                DispatchQueue.main.async {
                                    order.statusHistory = statusRes
                                    if (order.statusHistory.isEmpty) {
                                        order.statusHistory.append(statusCons[0])
                                    }
                                    
                                    var text2 = numberFormatter.string(from: NSNumber(value: (order.totalPrice)))
                                    if order.statusHistory[0].code == 2 {
                                        text2 = order.statusHistory[0].sellerDesc ?? statusCons[2].sellerDesc
                                    }
                                    
                                    list.append(ProductTableViewCellData(
                                        product_name: order.product?.product_name ?? "Unknown",
                                        product_image_url: order.product?.image_url ?? "",
                                        order_date: orderDate,
                                        delivery_method: order.deliveryMethod,
                                        status_text1: order.statusHistory[0].sellerDesc ?? statusCons[0].sellerDesc,
                                        status_text2: text2!))
                                    
                                    callback!(list)
                                }
                            }
                        }
                    }
                }
                callback!(list)
            }
        }
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
        cell.orderDateLabel.text = productData.order_date
        cell.deliveryMethodLabel.text = productData.delivery_method
        cell.firstStatusLabel.text = productData.status_text1
        cell.secondStatusLabel.text = productData.status_text2
        cell.productImageView.kf.setImage(with: URL(string: productData.product_image_url), placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch segmentedControl.selectedSegmentIndex {
        case 0: return "On my cart"
        case 1: return "Products ordered"
        default: return "Please select one option above"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Notification", bundle: Bundle.main).instantiateViewController(withIdentifier: "invoice") as? OrderInvoiceViewController
        vc?.orderModel = self.orderModels[indexPath.row]
        if segmentedControl.selectedSegmentIndex == 0 {
            vc?.isBuyer = true
        } else {
            vc?.isBuyer = false
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
