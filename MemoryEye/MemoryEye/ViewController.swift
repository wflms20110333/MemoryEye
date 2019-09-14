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
        let json: [String: Any] = ["images": [
            "url": "string",
            "tagIds": [
                "string"
            ]]]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        print(jsonData)
        
        // create post request
        let httpUrl = endpoint + "customvision/v3.0/training/projects/" + projectId + "/images/urls"
        guard let url = URL(string: httpUrl) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // set header values
        request.setValue("4b0f271e887740d2aa11154f42ee60b0", forHTTPHeaderField: "Training-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("insert-subscription-key-triggered", forHTTPHeaderField: "Training-key")
        
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("yay")
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
    }
}
