//
//  CategoryTableViewCell.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 22/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var catTitle: UILabel!
    @IBOutlet weak var catImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        styleViewCorner(catView)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
