//
//  OrderModel.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 30/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import Foundation

class OrderModel {
    
    var id:String?
    var productId: String
    var buyerUserId: String
    var invoiceNumber: String
    var totalPrice: Double
    var qty: Double
    var sendFrom: String
    var sendTo: String
    var receiverAddress: String
    var deliveryMethod: String
    var deliveryFee: Double
    var createdDate:Date
    var product:Product
    
    init(productId: String,
         buyerUserId: String,
         invoiceNumber: String,
         totalPrice: Double,
         qty: Double,
         sendFrom: String,
         sendTo: String,
         receiverAddress:String,
         deliveryMethod: String,
         deliveryFee: Double,
         createdDate: Date,
         product: Product) {
        self.productId = productId
        self.buyerUserId = buyerUserId
        self.invoiceNumber = invoiceNumber
        self.totalPrice = totalPrice
        self.qty = qty
        self.sendFrom = sendFrom
        self.sendTo = sendTo
        self.receiverAddress = receiverAddress
        self.deliveryMethod = deliveryMethod
        self.deliveryFee = deliveryFee
        self.createdDate = createdDate
        self.product = product
    }
}
