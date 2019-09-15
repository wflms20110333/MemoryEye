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

    var httpResponse: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        test()
    }
    
    func test() {
        print("Hello World")
//        train(imageUrl: "shhh")
    }
    
    func createTag(tag: String) -> String {
        sendRequest(method: "POST", apiUrl: "tags?name=" + tag, json: [:])
        return self.httpResponse["id"] as! String
    }
    
    func createImage(imageUrl: String, tagID: String) {
        // prepare json data
        let createImageJSON: [String: Any] = [
            "images": [
                [
                    "url": imageUrl
                ]
            ]
        ]
        
        sendRequest(method: "POST", apiUrl: "images/urls", json: createImageJSON)
//        let tagID = "3b8a6307-9326-4f5d-8e02-adc2a9dd8be4"
//        let imgID = "1d3d176e-3ba5-49c0-bf49-24fd1cd4351d"
        let imgID = self.httpResponse as j
        ["images"]?[0]["image"]["id"] as! String
        
        let associateJSON: [String: Any] = [
            "tags": [
                [
                    "imageId": imgID,
                    "tagId": tagID
                ]
            ]
        ]
        
        sendRequest(method: "POST", apiUrl: "images/tags", json: associateJSON)
    }
    
    func sendRequest(method: String, apiUrl: String, json: [String: Any]) {
//        let endpoint = "https://eastus.api.cognitive.microsoft.com/"
//        let projectId = "f248636d-d065-48fc-81ee-f7b43dbe613d"
        var headers: [String: String] = [:];
        headers["Training-Key"] = ""
        headers["Content-Type"] = "application/json"
        headers["Training-key"] = "4b0f271e887740d2aa11154f42ee60b0"
        
        
//
//        if let dumbass = jsonData, let JSONString = String(data: dumbass, encoding: String.Encoding.utf8) {
//            print(JSONString)
//        }
        
        // create request
        let httpUrl = "https://eastus.api.cognitive.microsoft.com/customvision/v3.0/training/projects/f248636d-d065-48fc-81ee-f7b43dbe613d/" + apiUrl
        guard let url = URL(string: httpUrl) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // set header values
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // prepare json data
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        // set body values
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("yay")
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                self.httpResponse = responseJSON
                print(responseJSON)
            }
        }
        task.resume()
        print("resuming")
    }
}
