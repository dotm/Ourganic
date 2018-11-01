//
//  TransferViewController.swift
//  Ourganic
//
//  Created by Ivan Fernando on 30/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class TransferViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var receiverAddress: UITextField!
    @IBOutlet weak var deliveryMethod: UILabel!
    @IBOutlet weak var deliveryFee: UILabel!
    @IBOutlet weak var sendToText: UITextField!
    @IBOutlet weak var produk: UILabel!
    @IBOutlet weak var store: UILabel!
    @IBOutlet weak var totalQty: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var uom: UILabel!
    @IBOutlet var cityPicker: UIPickerView! = UIPickerView()
    
    var product:Product?
    var totalHarga:Double?
    var totalQuantity:Double?
    var cities:[CityModel] = []
    var selectedRow:Int = 0
    
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
        
        styleTitleLabel(produk)
        styleTitleLabel(store)
        styleTitleLabel(totalQty)
        styleTitleLabel(location)
        styleTitleLabel(productPrice)
        styleTitleLabel(totalPrice)
        styleViewCorner(productImage)
        styleTitleLabel(uom)
        
        sendToText.layer.cornerRadius = 3
        productImage.contentMode = .scaleAspectFill
        productImage.clipsToBounds = true
        productImage.layer.cornerRadius = 10
        produk.text = product?.product_name
        store.text = product?.store_name
        totalQty.text = "\(totalQuantity!)"
        location.text = product?.location
        uom.text = product?.unit_measurement
        
        let formater = NumberFormatter()
        formater.numberStyle = .currency
        formater.locale = Locale(identifier: "id-ID")
        let prodPrice = formater.string(from: NSNumber(value: (product?.price_per_unit)!))
        productPrice.text = prodPrice
        
        let hargaTotal = formater.string(from: NSNumber(value: totalHarga!))
        totalPrice.text = hargaTotal
        self.productImage.kf.setImage(with: URL(string: (product?.image_url)!), placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didBeginEditing(_ sender: Any) {
        self.sendToText.text = cities[selectedRow].name
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
