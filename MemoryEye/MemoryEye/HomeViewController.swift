//
//  HomeViewController.swift
//  MemoryEye
//
//  Created by Peter T Tran on 9/14/19.
//  Copyright © 2019 Peter T Tran. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = self.navigationController?.navigationBar
        let alert = UIAlertController(title: "No image found :(", message: "Would you like to try again or see your list of memories?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(alert: UIAlertAction!) in NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nameOfNotification"), object: nil)}))
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        
        NotificationCenter.default.addObserver(self, selector: #selector(lol), name: NSNotification.Name(rawValue: "nameOfNotification"), object: nil)
        
        self.present(alert, animated: true)
        
        self.title = "Welcome Hacker"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func pushedMemoryEyeButton(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            present(vc, animated: true)
        }
//        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "lol") as?
//            ViewController
//        {
//            present(vc, animated: true, completion: nil)
//        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let alert = UIAlertController(title: "No image found :(", message: "Would you like to try again or see your list of memories?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(alert: UIAlertAction!) in NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nameOfNotification"), object: nil)}))
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        
        self.present(alert, animated: true)
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        // print out the image size as a test
        print(image.size)
    }
    
    @objc func lol() -> Void {
        print("fatass")
    }
}
