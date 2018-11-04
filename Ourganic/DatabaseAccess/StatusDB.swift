//
//  Category.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 25/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import Foundation
import Firebase

fileprivate let STATUS_COLLECTION:String = "status"
fileprivate let db = Firestore.firestore()

func statusModelToDictionary(status:StatusModel, orderId:String) -> [String:Any] {
    return [
        "order_id": orderId,
        "buyer_desc": status.buyerDesc,
        "code": status.code,
        "created_date": status.createdDate,
        "seller_desc": status.sellerDesc
    ]
}

func getStatusList (orderDocId:String, completion: @escaping (_ result: [StatusModel]) -> Void?) {
    let query = db.collection(STATUS_COLLECTION).order(by: "created_date", descending: true).whereField("order_id", isEqualTo: orderDocId).order(by: "code", descending: true)
    query.getDocuments { (result, error) in
        if let error = error {
            print("Error executing query to get status list:", error.localizedDescription)
            return
        }
        
        guard let statusDoc = result?.documents else { return }
        let statusList = statusDoc.map({ (statusModel) -> StatusModel in
            print("statusModel : \(statusModel.data())")
            return StatusModel(code: statusModel.data()["code"] as! Int, sellerDesc: statusModel.data()["seller_desc"] as! String, buyerDesc: statusModel.data()["buyer_desc"] as! String, createdDate: statusModel.data()["created_date"] as? Date ?? dateFromString(DATE_STR_NIL))
        })
        completion(statusList)
    }
}

func update(status: StatusModel, orderId:String, completion callback: (([StatusModel]?, Error?) -> Void)?){
    let statusDictionary: [String: Any] = statusModelToDictionary(status: status, orderId: orderId)
    db.collection(STATUS_COLLECTION).addDocument(data: statusDictionary) { (err) in
        getStatusList(orderDocId: orderId) { (resultUpdate) in
            callback?(resultUpdate, err)
        }
        
    }
}

