//
//  Category.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 25/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import Foundation
import Firebase

fileprivate let BANK_COLLECTION:String = "bank"
fileprivate let USER_BANK_COLLECTION:String = "user_bank"
fileprivate let db = Firestore.firestore()


func userBankModelToDictionary(bank:UserBankModel) -> [String:Any] {
    return [
        "account_number": bank.accountNumber,
        "account_name": bank.accountName,
        "bank_name": bank.bankName,
        "user_id": bank.userId
    ]
}


func getBankList (completion: @escaping (_ result: [BankModel]) -> Void) {
//    let query = db.collection(BANK_COLLECTION)
//    query.getDocuments { (result, error) in
//        if let error = error {
//            print("Error executing query to get bank list:", error.localizedDescription)
//            return
//        }
//
//        guard let bankDoc = result?.documents else { return }
//        let banks = bankDoc.map({ (bankModel) -> BankModel in
//            return BankModel(name: bankModel["name"] as! String)
//        })
//        completion(banks)
//    }
    let hardCode: [BankModel] = [
        BankModel(name: "BCA"),
        BankModel(name: "BNI"),
        BankModel(name: "Permata"),
        BankModel(name: "BRI"),
        BankModel(name: "Mandiri"),
        BankModel(name: "CIMB Niaga"),
    ]
    completion(hardCode)
}

func add(userBank: UserBankModel, userId:String, completion callback: ((UserBankModel?, Error?) -> Void)?){
    userBank.userId = userId
    let orderDictionary: [String: Any] = userBankModelToDictionary(bank: userBank)
    var doc : DocumentReference? = nil
    doc = db.collection(USER_BANK_COLLECTION).addDocument(data: orderDictionary) { (err) in
        userBank.id = doc?.documentID
        callback?(userBank, err)
    }
    
}
