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

func orderModelToDictionary(order:OrderModel) -> [String:Any] {
    return [
        "buyer_user_id": order.buyerUserId,
        "created_date": order.createdDate,
        "delivery_fee": order.deliveryFee,
        "delivery_method": order.deliveryMethod,
        "invoice_number": order.invoiceNumber,
        "product_id": order.productId,
        "qty": order.qty,
        "send_from": order.sendFrom,
        "send_to": order.sendTo,
        "receiver_address": order.receiverAddress,
        "total_price": order.totalPrice //TODO: save image
    ]
}

func getOrderList (userId: String, completion: @escaping (_ result: [OrderModel]) -> Void?) {
    let query = db.collection(ORDER_COLLECTION).whereField("buyer_user_id", isEqualTo: userId)
    query.getDocuments { (result, error) in
        if let error = error {
            print("Error executing query to get category list:", error.localizedDescription)
            return
        }
        guard let ordersDoc = result?.documents else { return }
        let orders = ordersDoc.map({ (order) -> OrderModel in
            print(order.data())
            
            let orderModel:OrderModel = OrderModel(productId: order.data()["product_id"] as! String, buyerUserId: userId, invoiceNumber: order.data()["invoice_number"] as! String, totalPrice: order.data()["total_price"] as! Double, qty: Double(order.data()["qty"] as! Int), sendFrom: order.data()["send_from"] as! String, sendTo: order.data()["send_to"] as! String, receiverAddress: order.data()["receiver_address"] as! String, deliveryMethod: order.data()["delivery_method"] as! String, deliveryFee: order.data()["delivery_fee"] as! Double, createdDate: order.data()["created_date"] as! Date)
            orderModel.id = order.documentID
            return orderModel
        })
        completion(orders)
    }
}

func add(order: OrderModel, userId:String, completion callback: ((OrderModel?, Error?) -> Void)?){
    order.buyerUserId = userId
    let orderDictionary: [String: Any] = orderModelToDictionary(order: order)
    var doc : DocumentReference? = nil
    doc = db.collection(ORDER_COLLECTION).addDocument(data: orderDictionary) { (err) in
        DispatchQueue.main.async {
            order.id = doc?.documentID
            let status = statusCons[0]
            status.createdDate = Date()
            update(status: statusCons[0], orderId: order.id!) { (result, error) in
                DispatchQueue.main.async {
                    order.statusHistory = result!
                    callback?(order, err ?? error ?? nil)
                }
            }
        }
    }
}

func getSellingList (userId: String, completion: @escaping (_ result: [OrderModel]) -> Void?) {
    let query = db.collection(ORDER_COLLECTION)
    var orderRet:[OrderModel] = []
    query.getDocuments { (result, error) in
        if let error = error {
            print("Error executing query to get category list:", error.localizedDescription)
            return
        }
        guard let ordersDoc = result?.documents else { return }
        let orders = ordersDoc.map({ (order) -> OrderModel in
            print(order.data())
            
            let orderModel:OrderModel = OrderModel(productId: order.data()["product_id"] as! String, buyerUserId: userId, invoiceNumber: order.data()["invoice_number"] as! String, totalPrice: order.data()["total_price"] as! Double, qty: Double(order.data()["qty"] as! Int), sendFrom: order.data()["send_from"] as! String, sendTo: order.data()["send_to"] as! String, receiverAddress: order.data()["receiver_address"] as! String, deliveryMethod: order.data()["delivery_method"] as! String, deliveryFee: order.data()["delivery_fee"] as! Double, createdDate: order.data()["created_date"] as! Date)
            orderModel.id = order.documentID
            return orderModel
        })
        
        getProductList(store_id: Store.ID!) { (prodRes, prodErr) in
            for ord in orders {
                for prod in prodRes {
                    if prod.product_id.elementsEqual(ord.productId) {
                        orderRet.append(ord)
                    }
                }
            }
             completion(orderRet)
        }
       
    }
}
