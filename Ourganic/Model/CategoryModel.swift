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
    
    init(name: String, imageUrl: String, desc: String) {
        self.imageUrl = imageUrl
        self.name = name
        self.desc = desc
    }
}
