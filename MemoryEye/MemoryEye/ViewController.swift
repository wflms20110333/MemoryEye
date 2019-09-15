//
//  ViewController.swift
//  MemoryEye
//
//  Created by Peter T Tran on 9/14/19.
//  Copyright © 2019 Peter T Tran. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase

class ViewController: UIViewController {

    let db = Database.database().reference()
    let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func uploadImage(img: UIImage) -> String {
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
    
    
    func storeNewMemory(loc: String, date: String, text: String, imgs: Array<UIImage>) {
        let tag = db.child("memories").childByAutoId().key
        
        db.child("memories").child(tag!).setValue(["loc": loc,
                                                   "date": date,
                                                   "text": text])
        
        var imgURLArray: Array<String> = Array()
        for img in imgs {
            let url = uploadImage(img: img)
            imgURLArray.append(url)
        }
        
        // use Elizabeth's stuff to get tagID (input imgURLArray)
        
    }
    
    // Matches the input image to an object in the database. Then, sends the info from the database related to the object
    // to frontend.
    func rememberMemory(img: UIImage) {
        
    }
    
}

