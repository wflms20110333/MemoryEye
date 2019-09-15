//
//  Memories.swift
//  MemoryEye
//
//  Created by Elizabeth Y Zou on 9/15/19.
//  Copyright © 2019 Peter T Tran. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import Foundation

class Memories {
    static let db = Database.database().reference()
    static let storage = Storage.storage().reference()
    
    // Helper function to add images to Firebase Storage, then retrieve its URL
    // Params: img (UIImage type)
    // Returns: url of the image
    static func uploadImage(img: UIImage) -> String {
        let imgPNG = img.pngData()!
        let imgRef = storage.child("name.jpg")
        
        // upload to firebase storage, then retrieve url
        var finalURL = "temp"
        let uploadTask = imgRef.putData(imgPNG, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // You can also access to download URL after upload.
            imgRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                finalURL = downloadURL.absoluteString
            }
        }
        return finalURL
    }
    
    static func setIterationNum(num: intmax_t) {
        db.child("memories").child("iterationNum").setValue(["n": num])
    }
    
    static func getIterationNum() -> intmax_t {
        var n = -1
        db.child("memories").child("iterationNum").observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() { return }
            let dict = snapshot.value as? NSDictionary
            n = dict?["n"] as? intmax_t ?? -1
        })
        return n
    }
    
    // Stores information into Firebase Realtime Database.
    // Params: loc (location of memory)
    //         date (date of memory)
    //         text (description of memory)
    //         name (name of memory)
    //         imgs (array of UIImages corresponding to the memory)
    // Returns: Nothing, just adds stuff to database and updates Custom Vision model.
    static func storeNewMemory(loc: String, date: String, text: String, name: String, imgs: Array<UIImage>) {
        let tag = db.child("memories").childByAutoId().key
        
        // Store location, date, text, and name into database
        db.child("memories").child(tag!).setValue(["loc": loc,
                                                   "date": date,
                                                   "text": text,
                                                   "name": name])
        var imgURLArray: Array<String> = Array()
        for img in imgs {
            let url = uploadImage(img: img)
            imgURLArray.append(url)
        }
        
        let tagID = ComputerVision.addTrainPublish(imageUrls: imgURLArray, tagName: tag ?? "")
        
        // Store img urls and tagID in database
        db.child("memories").child(tag!).setValue(["imgs": imgURLArray,
                                                   "tagID": tagID])
    }
    
    // Matches the input image to an object in the database and sends the info from the database related to the object to frontend.
    // Params: img (type UIImage)
    // Returns: info (date, location, time) corresponding to the object that the Custom Vision model predicts the image matches.
    static func rememberMemory(img: UIImage) {
        let imgURL = uploadImage(img: img)
        let n = getIterationNum()
        let probs = ComputerVision.classify(imageUrl: imgURL, publishName: "Iteration\(n)")
        
        // finish method based on what Elizabeth returns
    }
}
