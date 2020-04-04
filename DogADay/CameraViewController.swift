//
//  SecondViewController.swift
//  DogADay
//
//  Created by Bailey Brooks on 4/1/20.
//  Copyright © 2020 Bailey Brooks. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
        
        
    }
    
}

extension CameraViewController : UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[.originalImage] as? UIImage
    }
}

//import UIKit
//import AVFoundation
//import Foundation
//
//class CameraViewController: UIViewController, UINavigationControllerDelegate {
//    @IBOutlet weak var imgOverlay: UIImageView!
//    @IBOutlet weak var navigationBar: UINavigationBar!
//    @IBOutlet weak var btnCapture: UIButton!
//
//    @IBOutlet weak var shapeLayer: UIView!
//
//    let captureSession = AVCaptureSession()
//    let stillImageOutput = AVCapturePhotoOutput()
//    var previewLayer : AVCaptureVideoPreviewLayer?
//
//    var captureDevice : AVCaptureDevice?
//
//    // var imagePicker: UIImagePickerController!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//
//}
//
//extension UIImage {
//    convenience init(view: UIView) {
//        UIGraphicsBeginImageContext(view.frame.size)
//        view.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        self.init(cgImage: (image?.cgImage)!)
//    }
//}
//
//
//
//
//
//
//extension CameraViewController : UIImagePickerControllerDelegate {
//    @IBAction func takePhoto(_ sender: Any) {
//        imagePicker =  UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = .camera
//
//        present(imagePicker, animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        imagePicker.dismiss(animated: true, completion: nil)
//        imageView.image = info[.originalImage] as? UIImage
//    }
//}
//
