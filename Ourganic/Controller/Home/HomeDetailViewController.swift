//
//  HomeDetailViewController.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 24/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class HomeDetailViewController: UIViewController {

    @IBOutlet weak var categoryNameLbl: UILabel!
    @IBOutlet weak var prodTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        styleTitleLabel(categoryNameLbl)
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
