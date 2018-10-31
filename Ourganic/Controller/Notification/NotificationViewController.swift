//
//  NotificationViewController.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 30/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var onMyCartLbl: UILabel!
    @IBOutlet weak var cartCollectionView: UICollectionView!
    var onMyCart:[OrderModel] = []
    var myProduct:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleTitleLabel(onMyCartLbl)
        cartCollectionView.delegate = self
        cartCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return onMyCart.count
        } else {
            return myProduct.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ccell", for: indexPath) as! NotifCollectionViewCell
            let order = onMyCart[indexPath.row]
            cell.prodImage.kf.setImage(with: URL(string: order.product.image_url), placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ccell", for: indexPath) as! NotifCollectionViewCell
            let prod = myProduct[indexPath.row]
            cell.prodImage.kf.setImage(with: URL(string: prod.image_url), placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
            return cell
        }
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
