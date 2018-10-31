//
//  TransferViewController.swift
//  Ourganic
//
//  Created by Ivan Fernando on 30/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class TransferViewController: UIViewController {

    @IBOutlet weak var produk: UILabel!
    @IBOutlet weak var store: UILabel!
    @IBOutlet weak var totalQty: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    var product:Product?
    var totalHarga:Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(product?.product_name)
        produk.text = product?.product_name
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
