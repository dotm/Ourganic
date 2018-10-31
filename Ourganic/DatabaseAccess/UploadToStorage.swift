//
//  UploadToStorage.swift
//  Ourganic
//
//  Created by Yoshua Elmaryono on 31/10/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import Foundation
import Firebase

func getCurrentDate_asString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let currentDate: String = formatter.string(from: Date())
    
    return currentDate
}

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
    Timer.scheduledTimer(withTimeInterval: 120, repeats: false) { (_) in
        uploadTask.cancel()
        alertUser(title: "Upload Image Failed", message: "Upload image takes too long.")
    }
}
