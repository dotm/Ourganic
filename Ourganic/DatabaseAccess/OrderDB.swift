//
//  Category.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 25/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import Foundation
import Firebase

fileprivate let ORDER_COLLECTION:String = "order"
fileprivate let db = Firestore.firestore()

func getOrderList (userId: String, completion: @escaping (_ result: [OrderModel]) -> Void?) {
    let query = db.collection(ORDER_COLLECTION).whereField("buyer_user_id", isEqualTo: userId)
    query.getDocuments { (result, error) in
        if let error = error {
            print("Error executing query to get category list:", error.localizedDescription)
            return
        }
        
        guard let ordersDoc = result?.documents else { return }
        let orders = ordersDoc.map({ (order) -> OrderModel in
            var orders:OrderModel?
            getProductByDocId(documentId: order["product_id"] as! String) { (result, error) in
                orders = OrderModel(productId: order.data()["product_id"] as! String, buyerUserId: userId, invoiceNumber: order.data()["invoice_number"] as! String, totalPrice: order.data()["total_orice"] as! Double, qty: order.data()["qty"] as! Int, sendFrom: order.data()["send_from"] as! String, sendTo: order.data()["send_to"] as! String, deliveryMethod: order.data()["delivery_method"] as! String, deliveryFee: order.data()["delivery_fee"] as! Double, product: result)
                
            }
            return orders!
        })
        completion(orders)
    }
}

