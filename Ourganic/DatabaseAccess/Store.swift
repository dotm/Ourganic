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
class Store {
    private let db = Firestore.firestore()
    private let STORE_COLLECTION = "stores"
    
    private init() {
        //get ID of store
        let query = db.collection(STORE_COLLECTION).whereField("user_id", isEqualTo: User.ID)
        query.getDocuments { (result, error) in
            if let error = error {
                print("Error executing query to get store ID:", error.localizedDescription)
                return
            }
            
            guard let storeDocument = result?.documents.first else { return }
            self.ID = storeDocument.documentID
            
            let dataDictionary = storeDocument.data()
            guard let name = dataDictionary["name"] as? String else {
                fatalError("Can't retrieve store name")
            }
            let address = dataDictionary["address"] as? String
            let phone = dataDictionary["phone"] as? String
            self.storeData = (name: name, address: address, phone: phone, image: nil)
        }
    }
    
    var storeData: StoreData? = nil
    var ID: String? = nil
    private var storedInstance: Store? = nil
    var instance: Store {
        if let store = storedInstance {
            return store
        } else {
            let store = Store()
            storedInstance = store
            return store
        }
    }
    func register(store: StoreData, completion callback: ((Error?) -> Void)?){
        let storeData: [String: Any] = [
            "user_id": User.ID,
            "name": store.name,
            "address": store.address ?? "",
            "phone": store.phone ?? "",
            "image_url": "" //TODO: save image
        ]
        let documentRef = db.collection(STORE_COLLECTION).addDocument(data: storeData, completion: callback)
        self.ID = documentRef.documentID
    }
    
    private func saveStoreImage(image: UIImage){}
}
