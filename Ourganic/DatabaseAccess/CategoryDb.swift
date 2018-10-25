//
//  Category.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 25/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import Foundation
import Firebase

fileprivate let CATEGORY_COLLECTION:String = "category"
fileprivate let db = Firestore.firestore()

func getCategoryList (completion: @escaping (_ result: [CategoryModel]) -> Void?) {
    let query = db.collection(CATEGORY_COLLECTION).order(by: "order", descending: true)
    query.getDocuments { (result, error) in
        if let error = error {
            print("Error executing query to get store ID:", error.localizedDescription)
            return
        }
        
        guard let categoriesDoc = result?.documents else { return }
        let categories = categoriesDoc.map({ (catDoc) -> CategoryModel in
            var cat:CategoryModel?
            cat?.desc = catDoc["desc"] as! String
            cat?.imageUrl = catDoc["imageUrl"] as! String
            cat?.name = catDoc["name"] as! String
            return cat!
        })
        completion(categories)
    }
}
