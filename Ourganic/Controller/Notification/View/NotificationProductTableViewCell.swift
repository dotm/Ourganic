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
    let orderDateLabel = UILabel()
    let deliveryMethodLabel = UILabel()
    let firstStatusLabel = UILabel()
    let secondStatusLabel = UILabel()
    
    private let orderDateView = UIView()
    private let deliveryMethodView = UIView()

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
        setupOrderDateLabel()
        setupDeliveryMethodLabel(previousElement: orderDateView)
        setupFirstStatusLabel(previousElement: deliveryMethodView)
        setupSecondStatusLabel(previousElement: firstStatusLabel)
    }
    private let margin = CGFloat(10)
    private func setupImage(){
        let view = self
        
        let imageView = self.productImageView
        imageView.image = UIImage(named: "defaultimage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
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
        label.font = UIFont(name: "Avenir-Heavy", size: 12)
        label.backgroundColor = UIColor(named: "cGreen")
        view.addSubview(label)
        let container = self.productImageView
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
    }
    private func setupOrderDateLabel(){
        let view = self
        let containerView = self.orderDateView
        
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: margin).isActive = true
        containerView.topAnchor.constraint(equalTo: productImageView.topAnchor).isActive = true
        containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin).isActive = true
        
        let hardCodeLabel = UILabel()
        hardCodeLabel.text = "Order made"
        hardCodeLabel.textAlignment = .left
        hardCodeLabel.font = hardCodeLabel.font.withSize(13)
        containerView.addSubview(hardCodeLabel)
        hardCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        hardCodeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        hardCodeLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        hardCodeLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        hardCodeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        
        let dynamicLabel = self.orderDateLabel
        dynamicLabel.text = "78 Oct 2897 25:12"
        dynamicLabel.textAlignment = .right
        dynamicLabel.font = dynamicLabel.font.withSize(13)
        containerView.addSubview(dynamicLabel)
        dynamicLabel.translatesAutoresizingMaskIntoConstraints = false
        dynamicLabel.leadingAnchor.constraint(equalTo: hardCodeLabel.trailingAnchor).isActive = true
        dynamicLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        dynamicLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        dynamicLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
    private func setupDeliveryMethodLabel(previousElement: UIView){
        let view = self
        let containerView = self.deliveryMethodView
        
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: margin).isActive = true
        containerView.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: margin).isActive = true
        containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin).isActive = true
        
        let hardCodeLabel = UILabel()
        hardCodeLabel.text = "Delivery method"
        hardCodeLabel.textAlignment = .left
        hardCodeLabel.font = hardCodeLabel.font.withSize(13)
        containerView.addSubview(hardCodeLabel)
        hardCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        hardCodeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        hardCodeLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        hardCodeLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        hardCodeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        
        let dynamicLabel = self.deliveryMethodLabel
        dynamicLabel.text = "Fedex"
        dynamicLabel.textAlignment = .right
        dynamicLabel.font = dynamicLabel.font.withSize(13)
        containerView.addSubview(dynamicLabel)
        dynamicLabel.translatesAutoresizingMaskIntoConstraints = false
        dynamicLabel.leadingAnchor.constraint(equalTo: hardCodeLabel.trailingAnchor).isActive = true
        dynamicLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        dynamicLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        dynamicLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
    private func setupFirstStatusLabel(previousElement: UIView){
        let view = self
        let label = self.firstStatusLabel
        label.text = "Status 1"
        label.textColor = defaultTitleTextColor
        label.font = label.font.withSize(13)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: margin).isActive = true
        label.topAnchor.constraint(equalTo: previousElement.bottomAnchor, constant: margin).isActive = true
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin).isActive = true
    }
    private func setupSecondStatusLabel(previousElement: UIView){
        let view = self
        let label = self.secondStatusLabel
        label.text = "Status 2"
        label.textColor = defaultTitleTextColor
        label.font = label.font.withSize(13)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: margin).isActive = true
        label.topAnchor.constraint(equalTo: previousElement.bottomAnchor).isActive = true
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin).isActive = true
    }
}
