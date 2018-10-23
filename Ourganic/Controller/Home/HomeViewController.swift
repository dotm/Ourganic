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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AACarouselDelegate {

    @IBOutlet weak var carouselView: AACarousel!
    @IBOutlet weak var catTableView: UITableView!
    @IBOutlet var headerLabelList: [UILabel]!
    
    var categoryList:[Category] = []
    var titleArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catTableView.delegate = self
        catTableView.dataSource = self
        carouselView.delegate = self
        for label in headerLabelList {
            styleTitleLabel(label)
        }
        categoryList.append(Category(title: "Fruits & Vegetables", namedImage: "fnv"))
        categoryList.append(Category(title: "Fruits & Vegetables", namedImage: "fnv"))
        categoryList.append(Category(title: "Fruits & Vegetables", namedImage: "fnv"))
        categoryList.append(Category(title: "Fruits & Vegetables", namedImage: "fnv"))
        categoryList.append(Category(title: "Fruits & Vegetables", namedImage: "fnv"))
        categoryList.append(Category(title: "Fruits & Vegetables", namedImage: "fnv"))
        categoryList.append(Category(title: "Fruits & Vegetables", namedImage: "fnv"))
        catTableView.cellLayoutMarginsFollowReadableWidth = true
        catTableView.separatorColor = UIColor(white: 0, alpha: 0)
        titleArray = ["picture 1","picture 2","picture 3","picture 4","picture 5"]
        let pathArray = ["https://images.pexels.com/photos/767240/pexels-photo-767240.jpeg?auto=compress&cs=tinysrgb&h=350",
                         "https://ak.picdn.net/assets/cms/97e1dd3f8a3ecb81356fe754a1a113f31b6dbfd4-stock-photo-photo-of-a-common-kingfisher-alcedo-atthis-adult-male-perched-on-a-lichen-covered-branch-107647640.jpg",
                         "https://imgct2.aeplcdn.com/img/800x600/car-data/big/honda-amaze-image-12749.png",
                         "https://article.images.consumerreports.org/prod/content/dam/CRO%20Images%202018/Health/October/CR-Health-InlineHero-Eating-Organic-Cuts-Cancer-Risk-10-18",
                         "https://i.ndtvimg.com/i/2018-01/organic-food-in-india_650x400_41515066874.jpg"]
        carouselView.setCarouselData(paths: pathArray,  describedTitle: titleArray, isAutoScroll: true, timer: 5.0, defaultImage: "defaultImage")
        //optional methods
        carouselView.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
        carouselView.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: pathArray.count, pageIndicatorColor: nil, describedTitleColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), layerColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CategoryTableViewCell
        cell.catImage.image = UIImage(named: categoryList[indexPath.row].namedImage)
        cell.catTitle.text = categoryList[indexPath.row].title
        return cell
    }
    
    func didSelectCarouselView(_ view: AACarousel, _ index: Int) {
        let alert = UIAlertView.init(title:"Alert" , message: titleArray[index], delegate: self, cancelButtonTitle: "OK")
        alert.show()
        
        //startAutoScroll()
        //stopAutoScroll()
    }
    
    func callBackFirstDisplayView(_ imageView: UIImageView, _ url: [String], _ index: Int) {
       imageView.kf.setImage(with: URL(string: url[index]), placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
    }
    
    func downloadImages(_ url: String, _ index: Int) {
        //here is download images area
        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: url)!, placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(0))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
            self.carouselView.images[index] = downloadImage ?? UIImage(named: "defaultImage")!
        })
    }

}
