//
//  OrderModel.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 30/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import Foundation

class OrderModel {
    var productId: String
    var buyerUserId: String
    var invoiceNumber: String
    var totalPrice: Double
    var qty: Int
    var sendFrom: String
    var sendTo: String
    var deliveryMethod: String
    var deliveryFee: Double
    var product:Product
    
    init(productId: String,
         buyerUserId: String,
         invoiceNumber: String,
         totalPrice: Double,
         qty: Int,
         sendFrom: String,
         sendTo: String,
         deliveryMethod: String,
         deliveryFee: Double,
         product: Product) {
        self.productId = productId
        self.buyerUserId = buyerUserId
        self.invoiceNumber = invoiceNumber
        self.totalPrice = totalPrice
        self.qty = qty
        self.sendFrom = sendFrom
        self.sendTo = sendTo
        self.deliveryMethod = deliveryMethod
        self.deliveryFee = deliveryFee
        self.product = product
    }
}
