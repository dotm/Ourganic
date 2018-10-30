//
//  Store.swift
//  Ourganic
//
//  Created by Yoshua Elmaryono on 24/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import Foundation
import Firebase

typealias StoreData = (name: String, address: String?, phone: String?, image: UIImage?)

fileprivate let db = Firestore.firestore()
fileprivate let STORE_COLLECTION = "stores"

enum Store {
    //MARK: Private Properties
    //You must run initialize() or register() before the below value is initialized
    static private var store_id: String?
    static private var storeData: StoreData?
    //MARK: Public Properties
    static var ID: String? {
        guard let id = store_id else {
            print("No ID found for your store.")
            return nil
        }
        return id
    }
    static var name: String? {
        guard let data = storeData else {
            print("No data found for your store.")
            return nil
        }
        return data.name
    }
    //MARK: Actions
    static func register(store: StoreData, completion callback: ((Error?) -> Void)?){
        let storeData: [String: Any] = [
            "user_id": User.ID,
            "name": store.name,
            "address": store.address ?? "",
            "phone": store.phone ?? "",
            "image_url": "" //TODO: save image
        ]
        
        var ref: DocumentReference? = nil
        ref = db.collection(STORE_COLLECTION).addDocument(data: storeData) { (error) in
            if error == nil {
                Store.store_id = ref?.documentID
                Store.storeData = store
                initialized = true
            }
            
            callback?(error)
        }
    }
    static func add(product: ProductData, completion callback: ((Error?) -> Void)?){
        guard let store_id = store_id else {
            print("No ID found for your store.")
            return
        }
        let productData: [String: Any] = convertProductData_toProductDictionary(product, store_id: store_id, store_name: storeData!.name, image_url: "")
        
        var _ : DocumentReference? = db.collection(PRODUCT_COLLECTION).addDocument(data: productData, completion: callback)
    }
    
    //MARK: Initialization
    static private var initialized: Bool = false
    static func initialize(){
        guard initialized == false else { return }
        
        let query = db.collection(STORE_COLLECTION).whereField("user_id", isEqualTo: User.ID)
        query.getDocuments { (result, error) in
            if let error = error {
                print("Error executing query to get store ID:", error.localizedDescription)
                return
            }
            
            guard let storeDocument = result?.documents.first else { return }
            store_id = storeDocument.documentID
            
            let dataDictionary = storeDocument.data()
            guard let name = dataDictionary["name"] as? String else {
                fatalError("Can't retrieve store name")
            }
            let address = dataDictionary["address"] as? String
            let phone = dataDictionary["phone"] as? String
            storeData = (name: name, address: address, phone: phone, image: nil)
            
            initialized = true
        }
    }
    static func deinitialize(){
        store_id = nil
        storeData = nil
        initialized = false
    }
}
