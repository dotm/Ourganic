//
//  OrderDetailSatuViewController.swift
//  Ourganic
//
//  Created by Ivan Fernando on 30/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit
import Firebase

class OrderDetailSatuViewController: UIViewController {

    @IBOutlet weak var qtyStepper: PriceStepper!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var produk: UILabel!
    @IBOutlet weak var namaToko: UILabel!
    @IBOutlet weak var jenis: UILabel!
    @IBOutlet weak var harga: UILabel!
    @IBOutlet weak var minQty: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var deskripsi: UILabel!
    @IBOutlet weak var uom: UILabel!
    
    var idProduk: String = ""
    var TotalHarga: Double = 0
    var productModel:Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Product Detail"
        
        styleTitleLabel(produk)
        styleTitleLabel(namaToko)
        styleTitleLabel(jenis)
        styleTitleLabel(harga)
        styleTitleLabel(minQty)
        styleTitleLabel(location)
        styleTitleLabel(deskripsi)
        styleTitleLabel(uom)
        styleViewCorner(productImage)
        productImage.contentMode = .scaleAspectFill
        productImage.clipsToBounds = true
        productImage.layer.cornerRadius = 10
        getProductByDocId(documentId: idProduk) { (result, error) in
            DispatchQueue.main.async {
                self.produk.text = result.product_name
                self.namaToko.text = result.store_name
                self.jenis.text = result.product_name
                self.harga.text = String(result.price_per_unit)
                self.minQty.text = String(result.minimal_quantity)
                self.location.text = result.location
                self.deskripsi.text = result.description
                self.productImage.kf.setImage(with: URL(string: result.image_url), placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
                self.uom.text = result.unit_measurement
                self.qtyStepper.minimal_quantity = result.minimal_quantity
                self.qtyStepper.unit_measurement = result.unit_measurement
                self.productModel = (
                    product_id: self.idProduk,
                    store_id: result.store_id,
                    store_name: result.store_name,
                    product_name: result.product_name,
                    location: result.location,
                    category: result.category,
                    description: result.description,
                    minimal_quantity: result.minimal_quantity,
                    unit_measurement: result.unit_measurement,
                    price_per_unit: result.price_per_unit,
                    image_url: result.image_url
                )
            }
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func toTransfer(_ sender: Any) {
        let vc = UIStoryboard.init(name: "orderDetailView", bundle: Bundle.main).instantiateViewController(withIdentifier: "transferVC") as? TransferViewController
        let jumlahUnit = Double("\(qtyStepper.getTotalQty())") ?? 0
        let hargaUnit = Double(harga.text ?? "") ?? 0
        TotalHarga = jumlahUnit * hargaUnit
        print(self.productModel)
        vc?.product = self.productModel
        vc?.totalHarga = TotalHarga
        vc?.totalQuantity = jumlahUnit
        
        self.navigationController?.pushViewController(vc!, animated: true)
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
