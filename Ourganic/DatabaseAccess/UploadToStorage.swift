//
//  UploadToStorage.swift
//  Ourganic
//
//  Created by Yoshua Elmaryono on 31/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import Foundation
import Firebase

func uploadImage(imagePath: String, imageData: Data, completion: @escaping (URL?, Error?) -> Void){
    let storageRef = Storage.storage().reference()
    let spaceRef = storageRef.child(imagePath)
    let uploadTask = spaceRef.putData(imageData, metadata: nil) { (metadata, error) in
        guard let _ = metadata else {
            print("Error uploading user image:", error!)
            return
        }
        spaceRef.downloadURL(completion: completion)
    }
    uploadTask.enqueue()
}
