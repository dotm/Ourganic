//
//  Category.swift
//  Ourganic
//
//  Created by Firmansyah Putra on 22/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import Foundation
class CategoryModel {
    var imageUrl: String
    var name: String
    var desc:String
    var code:String
    var type:String
    
    init(name: String, imageUrl: String, desc: String, code: String, type: String) {
        self.imageUrl = imageUrl
        self.name = name
        self.desc = desc
        self.code = code
        self.type = type
    }
}
