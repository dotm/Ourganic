//
//  HomeViewController.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 22/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var catTableView: UITableView!
    @IBOutlet var headerLabelList: [UILabel]!
    
    var categoryList:[Category] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        catTableView.delegate = self
        catTableView.dataSource = self
        for label in headerLabelList {
            styleTitleLabel(label)
        }
        categoryList.append(Category(title: "Fruits & Vegetables", namedImage: "fnv"))
        catTableView.cellLayoutMarginsFollowReadableWidth = true
        catTableView.separatorColor = UIColor(white: 0, alpha: 0)
        // Do any additional setup after loading the view.
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

}
