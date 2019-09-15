//
//  ViewController.swift
//  MemoryEye
//
//  Created by Peter T Tran on 9/14/19.
//  Copyright © 2019 Peter T Tran. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        test()
    }
    
    func test() {
        print("Hello World")
        train(imageUrl: "shhh")
    }
    
    func train(imageUrl: String) {
        let endpoint = "https://eastus.api.cognitive.microsoft.com/"
        let projectId = "f248636d-d065-48fc-81ee-f7b43dbe613d"
        
        // prepare json data
        let json: [String: Any] = [
            "images": [
                [
                    "url": "https://cdn11.bigcommerce.com/s-zb4ffa3sum/images/stencil/1280x1280/products/11485/11748/Mouse-ELISA-Assays__68488.1533166943.jpg",
                    "tagIds": [
                        "mouse"
                    ],
                    "regions": [
                        [
                            "tagId": "mouse",
                            "left": 0.0,
                            "top": 0.0,
                            "width": 0.0,
                            "height": 0.0
                        ]
                    ]
                ]
            ],
            "tagIds": [
                "mouse"
            ]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        if let dumbass = jsonData, let JSONString = String(data: dumbass, encoding: String.Encoding.utf8) {
            print(JSONString)
        }
//
//        {
//            "images": [
//                {
//                    "regions": [
//                        {
//                            "left": 0,
//                            "top": 0,
//                            "width": 0,
//                            "height": 0,
//                            "tagId": "mouse"
//                        }
//                    ],
//                    "url": "https:\/\/cdn11.bigcommerce.com\/s-zb4ffa3sum\/images\/stencil\/1280x1280\/products\/11485\/11748\/Mouse-ELISA-Assays__68488.1533166943.jpg",
//                    "tagIds": [
//                        "mouse"
//                    ]
//                }
//            ],
//            "tagIds": [
//                "mouse"
//            ]
//        }
        
        // create post request
        let httpUrl = endpoint + "customvision/v3.0/training/projects/" + projectId + "/images/urls"
        guard let url = URL(string: httpUrl) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // set header values
        request.setValue("", forHTTPHeaderField: "Training-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("4b0f271e887740d2aa11154f42ee60b0", forHTTPHeaderField: "Training-key")
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("yay")
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            print(responseJSON)
            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON)
            }
        }
        task.resume()
    }
}
