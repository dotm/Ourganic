//
//  HomeDetailViewController.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 24/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class HomeDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var categoryNameLbl: UILabel!
    @IBOutlet weak var prodTableView: UITableView!
    @IBOutlet weak var emptyMsgView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredProducts:[Product] = []
    var productListMaster:[Product] = []
    var categoryModel:CategoryModel?
    var productList:[Product] = []
    var keyword:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyMsgView.isHidden = true
        styleTitleLabel(categoryNameLbl)
        navigationItem.title = categoryModel?.name
        prodTableView.delegate = self
        prodTableView.dataSource = self
        searchBar.delegate = self
        prodTableView.cellLayoutMarginsFollowReadableWidth = true
        prodTableView.separatorColor = UIColor(white: 0, alpha: 0)
        
        getProductList(category_code: (categoryModel?.code ?? ""), keyword: keyword) { (result, error) in
            DispatchQueue.main.async {
                self.productList = result
                self.productListMaster = result
                if self.categoryModel?.type.lowercased() == "h" {
                    self.categoryNameLbl.text = "Our Promo"
                } else {
                     self.categoryNameLbl.text = self.categoryModel?.name ?? "Search result by \"\(self.keyword)\""
                }
                self.prodTableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
        
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            productList = productListMaster
        } else {
            filteredProducts = productListMaster.filter({( product : Product) -> Bool in
                return product.product_name.lowercased().contains(searchText.lowercased())
            })
            productList = filteredProducts
        }
        prodTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productList.count == 0 {
            emptyMsgView.isHidden = false
            tableView.isHidden = true
        } else {
            emptyMsgView.isHidden = true
            tableView.isHidden = false
        }
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
        let formater = NumberFormatter()
        formater.numberStyle = .currency
        formater.locale = Locale(identifier: "id-ID")
        let prodPrice = formater.string(from: NSNumber(value: productList[indexPath.row].price_per_unit))
        cell.prodPrice.text = prodPrice
        cell.prodUnit.text = productList[indexPath.row].unit_measurement
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! ProductTableViewCell
        selectedCell.isSelected = false
        let vc = UIStoryboard.init(name: "Product", bundle: Bundle.main).instantiateViewController(withIdentifier: "prod detail") as? ProductDetailViewController
        vc?.idProduk = productList[indexPath.row].product_id
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filterContentForSearchText(searchBar.text ?? "")
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
