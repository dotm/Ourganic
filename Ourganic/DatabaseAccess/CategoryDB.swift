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
fileprivate let HEADLINE_COLLECTION:String = "headline"
fileprivate let db = Firestore.firestore()

func getCategoryList (completion: @escaping (_ result: [CategoryModel]) -> Void?) {
    let query = db.collection(CATEGORY_COLLECTION).whereField("type", isEqualTo: "c").order(by: "order", descending: false)
    query.getDocuments { (result, error) in
        if let error = error {
            print("Error executing query to get category list:", error.localizedDescription)
            return
        }
        
        guard let categoriesDoc = result?.documents else { return }
        let categories = categoriesDoc.map({ (catDoc) -> CategoryModel in
            let cat = CategoryModel(name: catDoc["name"] as! String, imageUrl: catDoc["image_url"] as! String, desc: catDoc["desc"] as! String, code: catDoc["code"] as! String)
            return cat
        })
        completion(categories)
    }
}

func getHeadlineList (completion: @escaping (_ result: [CategoryModel]) -> Void?) {
    let query = db.collection(CATEGORY_COLLECTION).whereField("type", isEqualTo: "h").order(by: "order", descending: false)
    query.getDocuments { (result, error) in
        if let error = error {
            print("Error executing query to get category list:", error.localizedDescription)
            return
        }
        
        guard let categoriesDoc = result?.documents else { return }
        let categories = categoriesDoc.map({ (catDoc) -> CategoryModel in
            let cat = CategoryModel(name: catDoc["name"] as! String, imageUrl: catDoc["image_url"] as! String, desc: catDoc["desc"] as! String, code: catDoc["code"] as! String)
            return cat
        })
        completion(categories)
    }
}
