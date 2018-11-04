//
//  Formatter.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 05/11/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import Foundation

func currencyFormatterUtil(_ number:Double) -> String {
    let formater = NumberFormatter()
    formater.numberStyle = .currency
    formater.locale = Locale(identifier: "id-ID")
    return formater.string(from: NSNumber(value: number)) ?? "Error acquired"
}

func dateFormatterUtil(_ date:Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
    return dateFormatter.string(from: date)
}

func dateFromString(_ dateStr:String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
    return dateFormatter.date(from: dateStr)!
}
