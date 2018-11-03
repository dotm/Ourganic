//
//  Category.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 25/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import Foundation
import Firebase

fileprivate let CITY_COLLECTION:String = "city"
fileprivate let db = Firestore.firestore()

func getCityList (completion: @escaping (_ result: [CityModel]) -> Void) {
    let query = db.collection(CITY_COLLECTION)
    query.getDocuments { (result, error) in
        if let error = error {
            print("Error executing query to get category list:", error.localizedDescription)
            return
        }
        
        guard let cityDoc = result?.documents else { return }
        let cities = cityDoc.map({ (cityModel) -> CityModel in
            return CityModel(name: cityModel["name"] as! String)
        })
        completion(cities)
    }
}

