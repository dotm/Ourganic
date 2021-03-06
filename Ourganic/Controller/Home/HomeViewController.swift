//
//  HomeViewController.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 22/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit
import AACarousel
import Kingfisher
import SideMenu

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AACarouselDelegate, UISearchBarDelegate {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var carouselView: AACarousel!
    @IBOutlet weak var catTableView: UITableView!
    @IBOutlet var headerLabelList: [UILabel]!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var categoryList:[CategoryModel] = []
    var headlineList:[CategoryModel] = []
    var titleArray:[String] = []
    var pathArray:[String] = []
    
    var  orderedProduct:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !orderedProduct.isEmpty {
            let alert = UIAlertController(title: "Order Added", message: "Your order \"\(orderedProduct)\" has been added", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
        }
        
        catTableView.delegate = self
        catTableView.dataSource = self
        carouselView.delegate = self
        searchBar.delegate = self
        for label in headerLabelList {
            styleTitleLabel(label)
        }
        
        getCategoryList() { (resultCategory) in
            DispatchQueue.main.async {
                self.categoryList = resultCategory
                self.catTableView.reloadData()
            }
            
        }
        
        getHeadlineList() { (resultHeadline) in
            DispatchQueue.main.async {
                self.headlineList = resultHeadline
                self.carouselView.reloadInputViews()
                for catModel in self.headlineList {
                    self.titleArray.append(catModel.name)
                    self.pathArray.append(catModel.imageUrl)
                }
                self.carouselView.setCarouselOpaque(layer: true, describedTitle: true, pageIndicator: false)
                self.carouselView.setCarouselData(paths: self.pathArray,  describedTitle: self.titleArray, isAutoScroll: true, timer: 5.0, defaultImage: "defaultImage")
            }
            
        }
       
        catTableView.cellLayoutMarginsFollowReadableWidth = true
        catTableView.separatorColor = UIColor(white: 0, alpha: 0)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoryTableViewCell
        cell.catImage.contentMode = .scaleAspectFill
        cell.catImage.clipsToBounds = true
        cell.catImage.layer.cornerRadius = 10
        cell.catImage.kf.setImage(with: URL(string: categoryList[indexPath.row].imageUrl))
        cell.catTitle.text = categoryList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
        selectedCell.isSelected = false
        let vc = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "homeDetail") as? HomeDetailViewController
        vc?.categoryModel = categoryList[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func callBackFirstDisplayView(_ imageView: UIImageView, _ url: [String], _ index: Int) {
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.kf.setImage(with: URL(string: url[index]), placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
    }
    
    func downloadImages(_ url: String, _ index: Int) {
        //here is download images area
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.kf.setImage(with: URL(string: url)!, placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(0))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
            self.carouselView.images[index] = downloadImage ?? UIImage(named: "defaultImage")!
        })
    }
    
    func didSelectCarouselView(_ view: AACarousel, _ index: Int) {
        let vc = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "homeDetail") as? HomeDetailViewController
        vc?.categoryModel = headlineList[index]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text, !searchBarText.isEmpty else {
            return
        }
        let vc = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "homeDetail") as? HomeDetailViewController
        vc?.keyword = searchBarText
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
