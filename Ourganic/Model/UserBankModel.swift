//
//  UserBankModel.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 02/11/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import Foundation

class UserBankModel {
    
    var id:String?
    var accountName:String?
    var accountNumber:String?
    var bankName:String?
    var userId:String?
    
    init(accountName:String,
         accountNumber:String,
         bankName:String,
         userId:String) {
        self.accountName = accountName
        self.accountNumber = accountNumber
        self.bankName = bankName
        self.userId = userId
    }
}
