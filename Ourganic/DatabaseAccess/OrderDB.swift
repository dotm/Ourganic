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
fileprivate let HEADLINE_COLLECTION:String = "headline"
fileprivate let db = Firestore.firestore()

func getOrderList (userId: String, completion: @escaping (_ result: [OrderModel]) -> Void?) {
    let query = db.collection(ORDER_COLLECTION).whereField("buyer_user_id", isEqualTo: userId)
    query.getDocuments { (result, error) in
        if let error = error {
            print("Error executing query to get category list:", error.localizedDescription)
            return
        }
        
        guard let ordersDoc = result?.documents else { return }
        let orders = ordersDoc.map({ (order) -> CategoryModel in
            getPro
            return cat
        })
        completion(categories)
    }
}

