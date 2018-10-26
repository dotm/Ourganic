//
//  HomeDetailViewController.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 24/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class HomeDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var categoryNameLbl: UILabel!
    @IBOutlet weak var prodTableView: UITableView!
    
    var category:CategoryModel?
    var productList:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleTitleLabel(categoryNameLbl)
        categoryNameLbl.text = category?.name
        prodTableView.delegate = self
        prodTableView.dataSource = self
        prodTableView.cellLayoutMarginsFollowReadableWidth = true
        prodTableView.separatorColor = UIColor(white: 0, alpha: 0)
        getProductList(category_code: (category?.code)!) { (result, error) in
            DispatchQueue.main.async {
                self.productList = result
                self.prodTableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductTableViewCell
        cell.prodImage.contentMode = .scaleAspectFill
        cell.prodImage.clipsToBounds = true
        cell.prodImage.layer.cornerRadius = 10
        cell.prodImage.kf.setImage(with: URL(string: productList[indexPath.row].image_url), placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
        cell.prodName.text = productList[indexPath.row].product_name
        cell.prodLoc.text = productList[indexPath.row].location
        cell.prodPrice.text = "\(productList[indexPath.row].price_per_unit)"
        cell.prodUnit.text = productList[indexPath.row].unit_measurement
        return cell
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
