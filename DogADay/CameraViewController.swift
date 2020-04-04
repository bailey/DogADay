//
//  SecondViewController.swift
//  DogADay
//
//  Created by Bailey Brooks on 4/1/20.
//  Copyright © 2020 Bailey Brooks. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prevents crashing in the simulator
        if !UIImagePickerController.isSourceTypeAvailable(.camera){

            let alertController = UIAlertController.init(title: nil, message: "Device has no camera.", preferredStyle: .alert)

            let okAction = UIAlertAction.init(title: "Ok 🥺", style: .default, handler: {(alert: UIAlertAction!) in
            })

            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)

            return
        }
        
        
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
       let overlayView = OverlayView(frame: frame)
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraOverlayView = overlayView
        
        present(imagePicker, animated: true, completion: nil)
  
//        //hide all controls
//        picker.showsCameraControls = NO;
//        picker.navigationBarHidden = YES;
//        picker.toolbarHidden = YES;
        //make the video preview full size
//        picker.wantsFullScreenLayout = YES;
//        picker.cameraViewTransform =
//        CGAffineTransformScale(picker.cameraViewTransform,
//                               CAMERA_TRANSFORM_X,
//                               CAMERA_TRANSFORM_Y);
//        //set our custom overlay view
//        picker.cameraOverlayView = overlay;
        
        //show picker
       // [self presentModalViewController:picker animated:YES];
        
        
    }
}

//extension CameraViewController : UIImagePickerControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        imagePicker.dismiss(animated: true, completion: nil)
//        imageView.image = info[.originalImage] as? UIImage
//    }
//}

class OverlayView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //clear the background color of the overlay
        self.isOpaque = false
        self.backgroundColor = .blue
        
        //load an image to show in the overlay
        let crosshair = UIImage(named: "home.png")
        let crosshairView = UIImageView(image: crosshair)
        //crosshairView.frame = CGRectMake(0, 40, 320, 300);
        crosshairView.contentMode = .center
        self.addSubview(crosshairView)
        
//        //add a simple button to the overview
//        //with no functionality at the moment
//        UIButton *button = [UIButton
//                            buttonWithType:UIButtonTypeRoundedRect];
//        [button setTitle:@"Catch now" forState:UIControlStateNormal];
//        button.frame = CGRectMake(0, 430, 320, 40);
//        [self addSubview:button];
//        }
//        return self;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
