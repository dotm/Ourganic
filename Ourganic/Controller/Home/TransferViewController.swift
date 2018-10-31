//
//  TransferViewController.swift
//  Ourganic
//
//  Created by Ivan Fernando on 30/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class TransferViewController: UIViewController {

    @IBOutlet weak var sendToText: UITextField!
    @IBOutlet weak var produk: UILabel!
    @IBOutlet weak var store: UILabel!
    @IBOutlet weak var totalQty: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    var product:Product?
    var totalHarga:Double?
    var totalQuantity:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Product Detail"
        
        styleTitleLabel(produk)
        styleTitleLabel(store)
        styleTitleLabel(totalQty)
        styleTitleLabel(location)
        styleTitleLabel(productPrice)
        styleTitleLabel(totalPrice)
        styleViewCorner(productImage)
        
        produk.text = product?.product_name
        store.text = product?.store_name
        totalQty.text = String(describing: totalQuantity)
        location.text = product?.location
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
