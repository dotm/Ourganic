//
//  Product.swift
//  Ourganic
//
//  Created by Yoshua Elmaryono on 25/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import Foundation
import Firebase

fileprivate let db = Firestore.firestore()

typealias Product = (
    store_id: String,
    store_name: String,
    product_name: String,
    location: String,
    category: String,
    description: String,
    minimal_quantity: Double,
    unit_measurement: String,
    price_per_unit: Double,
    image_url: String
)
let PRODUCT_COLLECTION = "products"

func convertProductDictionary_toProductData(_ dataDictionary: [String:Any]) -> Product {
    let store_id = dataDictionary["store_id"] as! String
    let store_name = dataDictionary["store_name"] as! String
    let product_name = dataDictionary["product_name"] as! String
    let location = dataDictionary["location"] as! String
    let category = dataDictionary["category"] as! String
    let description = dataDictionary["description"] as! String
    let minimal_quantity = dataDictionary["minimal_quantity"] as! Double
    let unit_measurement = dataDictionary["unit_measurement"] as! String
    let price_per_unit = dataDictionary["price_per_unit"] as! Double
    let image_url = dataDictionary["image_url"] as! String
    
    return (
        store_id,
        store_name,
        product_name,
        location,
        category,
        description,
        minimal_quantity,
        unit_measurement,
        price_per_unit,
        image_url
    )
}
func convertProductData_toProductDictionary(_ product: Product, store_id: String, store_name: String, image_url: String) -> [String:Any] {
    return [
        "store_id": store_id,
        "store_name": store_name,
        "product_name": product.product_name,
        "location": product.location,
        "category": product.category,
        "description": product.description,
        "minimal_quantity": product.minimal_quantity,
        "unit_measurement": product.unit_measurement,
        "price_per_unit": product.price_per_unit,
        "image_url": image_url //TODO: save image
    ]
}

func getProductList(store_id: String, completion callback: (([Product], Error?) -> Void)?){
    let query = db.collection(PRODUCT_COLLECTION).whereField("store_id", isEqualTo: store_id)
    query.getDocuments { (result, error) in
        if let error = error {
            print("Error executing query to get product list:", error.localizedDescription)
            return
        }
        
        guard let productDocuments = result?.documents else { return }
        let products = productDocuments.map({ (document) -> Product in
            return convertProductDictionary_toProductData(document.data())
        })
        
        callback?(products, error)
    }
}
