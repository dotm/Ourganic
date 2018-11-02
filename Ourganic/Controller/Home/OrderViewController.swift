//
//  TransferViewController.swift
//  Ourganic
//
//  Created by Ivan Fernando on 30/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var receiverAddress: UITextField!
    @IBOutlet weak var deliveryMethod: UILabel!
    @IBOutlet weak var deliveryFeeText: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var sendToText: UITextField!
    @IBOutlet weak var store: UILabel!
    @IBOutlet weak var totalQty: UILabel!
    @IBOutlet weak var sendFrom: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var uom: UILabel!
    @IBOutlet var cityPicker: UIPickerView! = UIPickerView()
    
    var product:Product?
    var totalHarga:Double?
    var totalQuantity:Double?
    var deliveryFee:Double?
    var cities:[CityModel] = []
    var selectedRow:Int = 0
    let formater = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Product Detail"
        cityPicker.delegate = self
        cityPicker.dataSource = self
        sendToText.inputView = cityPicker
        getCityList() { (result) in
            DispatchQueue.main.async {
                self.cities = result
            }
        }
        
        styleTitleLabel(productName)
        styleTitleLabel(store)
        styleTitleLabel(totalQty)
        styleTitleLabel(sendFrom)
        styleTitleLabel(productPrice)
        styleTitleLabel(totalPrice)
        styleViewCorner(productImage)
        styleTitleLabel(uom)
        
        sendToText.layer.cornerRadius = 3
        productImage.contentMode = .scaleAspectFill
        productImage.clipsToBounds = true
        productImage.layer.cornerRadius = 10
        productName.text = product?.product_name
        store.text = product?.store_name
        totalQty.text = "\(totalQuantity!)"
        sendFrom.text = product?.location
        uom.text = product?.unit_measurement
        
        
        formater.numberStyle = .currency
        formater.locale = Locale(identifier: "id-ID")
        let prodPrice = formater.string(from: NSNumber(value: (product?.price_per_unit)!))
        productPrice.text = prodPrice
        
        deliveryFeeText.text = formater.string(from: NSNumber(value: 0.0))
        
        let hargaTotal = formater.string(from: NSNumber(value: totalHarga!))
        totalPrice.text = hargaTotal
        self.productImage.kf.setImage(with: URL(string: (product?.image_url)!), placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didBeginEditing(_ sender: Any) {
        self.sendToText.text = cities[selectedRow].name
        self.deliveryFee = 9000.0
        self.deliveryFeeText.text = formater.string(from: NSNumber(value: deliveryFee ?? 0))
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.selectedRow = row
        return cities[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sendToText.text = cities[row].name
    }
    
    @IBAction func makeOrder(_ sender: UIButton) {
        if (!User.isLoggedIn()) {
            goTo_loginPage()
        } else {
            if(sendToText.text?.isEmpty ?? true) {
                let alert = UIAlertView.init(title:"Alert" , message: "\"Send To\" is empty!", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                return
            }
            if(receiverAddress.text?.isEmpty ?? true) {
                let alert = UIAlertView.init(title:"Alert" , message: "\"Receiver Address\" is empty!", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                return
            }
            let sequence = String(format: "%03d", arc4random_uniform(999))
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "ddMMyyyyHHmmss"
            let invoiceNumber = "INV"+formatter.string(from: date)+sequence
            let order:OrderModel = OrderModel(productId: (self.product?.product_id)!, buyerUserId: User.ID!, invoiceNumber: invoiceNumber, totalPrice: totalHarga!, qty: totalQuantity!, sendFrom: sendFrom.text!, sendTo: sendToText.text!, receiverAddress: receiverAddress.text!, deliveryMethod: deliveryMethod.text!, deliveryFee: deliveryFee!, createdDate: date, product: product!)
            add(order: order, userId: User.ID!) { (result, err) in
                if err != nil {
                    let alert = UIAlertView.init(title:"Alert" , message: err!.localizedDescription , delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    return
                }
                if(sender.tag == 0) {
                    let vc = UIStoryboard.init(name: "Product", bundle: Bundle.main).instantiateViewController(withIdentifier: "Invoice") as? InvoiceViewController
                    vc?.order = order
                    self.navigationController?.pushViewController(vc!, animated: true)
                } else {
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
                    
                    //                    vc?.orderedProduct = result!.product.product_name
                    //                    self.navigationController?.popToViewController(vc!, animated: true)
                }
            }
        }
    }
    
    @objc private func goTo_loginPage(){
        present(LoginUserViewController(), animated: true, completion: nil)
    }
}
