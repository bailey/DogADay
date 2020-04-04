//
//  SecondViewController.swift
//  DogADay
//
//  Created by Bailey Brooks on 4/1/20.
//  Copyright © 2020 Bailey Brooks. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera

        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[.originalImage] as? UIImage
    }
}

