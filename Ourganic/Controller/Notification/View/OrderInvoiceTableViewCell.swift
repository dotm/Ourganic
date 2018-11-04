//
//  OrderInvoiceTableViewCell.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 04/11/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class OrderInvoiceTableViewCell: UITableViewCell {

    @IBOutlet weak var pointLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusExtraLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
