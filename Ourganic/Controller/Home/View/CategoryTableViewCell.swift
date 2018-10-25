//
//  CategoryTableViewCell.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 22/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var catViewLabel: UIView!
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var catTitle: UILabel!
    @IBOutlet weak var catImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        styleViewCorner(catView)
        catViewLabel.layer.cornerRadius = 10
        catViewLabel.layer.borderWidth = 0.3
        catViewLabel.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
