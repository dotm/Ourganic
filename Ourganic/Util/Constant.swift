//
//  Constant.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 03/11/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import Foundation

enum status {
    static let WAITING_PAYMENT:Int = 0
    static let WAITING_APPROVAL:Int = 1
    static let APPROVE:Int = 2
    static let DONE:Int = 3
}

let DATE_STR_NIL:String = "01-01-1990 00:00"

private let statusStrSeller:[String] = ["Waiting for payment", "Need your approval", "You just approved the order", "Transaction success"]

private let statusStrBuyer:[String] = ["Waiting for payment", "Waiting for approval", "Seller just approved your order", "Transaction success"]

let statusCons:[StatusModel] = [
    StatusModel(code: 0, sellerDesc: statusStrSeller[0], buyerDesc: statusStrBuyer[0]),
    StatusModel(code: 1, sellerDesc: statusStrSeller[1], buyerDesc: statusStrBuyer[1]),
    StatusModel(code: 2, sellerDesc: statusStrSeller[2], buyerDesc: statusStrBuyer[2]),
    StatusModel(code: 3, sellerDesc: statusStrSeller[3], buyerDesc: statusStrBuyer[3])]
