//
//  ProductTableViewCell.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 24/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var prodView: UIView!
    @IBOutlet weak var prodUnit: NSLayoutConstraint!
    @IBOutlet weak var prodPrice: UILabel!
    @IBOutlet weak var prodLoc: UILabel!
    @IBOutlet weak var prodName: NSLayoutConstraint!
    @IBOutlet weak var prodDescView: UIView!
    @IBOutlet weak var prodImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        styleViewCorner(prodView)
        prodDescView.layer.cornerRadius = 10
        prodDescView.layer.borderWidth = 0.3
        prodDescView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
