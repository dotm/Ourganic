//
//  StatusModel.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 03/11/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import Foundation

class StatusModel {
    var code:Int
    var sellerDesc:String
    var buyerDesc:String
    var createdDate:Date?
    
    init(code: Int, sellerDesc: String, buyerDesc: String) {
        self.code = code
        self.sellerDesc = sellerDesc
        self.buyerDesc = buyerDesc
    }
    
    init(code: Int, sellerDesc: String, buyerDesc: String, createdDate:Date) {
        self.code = code
        self.sellerDesc = sellerDesc
        self.buyerDesc = buyerDesc
        self.createdDate = createdDate
    }
}
