//
//  NotificationProductTableViewCell.swift
//  
//
//  Created by Yoshua Elmaryono on 02/11/18.
//

import UIKit

class NotificationProductTableViewCell: UITableViewCell {
    let productImageView = UIImageView()
    let productNameLabel = UILabel()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    private func setupLayout(){
        setupImage()
        setupProductName()
    }
    private func setupImage(){
        let view = self
        
        let imageView = self.productImageView
        imageView.image = UIImage(named: "defaultimage")

        view.addSubview(imageView)
        let margin = CGFloat(10)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2*margin).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: margin).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
    }
    private func setupProductName(){
        let view = self
        
        let label = self.productNameLabel
        label.text = "Product Name"
        label.textColor = .white
        label.textAlignment = .center
        
        view.addSubview(label)
        let container = self.productImageView
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
    }
}
