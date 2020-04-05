//
//  SecondViewController.swift
//  DogADay
//
//  Created by Bailey Brooks on 4/1/20.
//  Copyright © 2020 Bailey Brooks. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class CameraViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var toggleFlashButton: UIButton!
    @IBOutlet weak var captureImageButton: UIButton!
    @IBOutlet weak var capturePreviewView: UIView!
    
    @IBOutlet weak var comeBackLaterView: UIView!
    
    let captureSession = AVCaptureSession()
    
    let previewLayer = AVCaptureVideoPreviewLayer() // TODO is this a bug? later on we construct it with a session as an object
    
    var photoOutput: AVCapturePhotoOutput?
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    
    var captureDevice: AVCaptureDevice?

    var flashMode = AVCaptureDevice.FlashMode.off
    
    var currentImage: UIImage?

    var windowOrientation: UIInterfaceOrientation {
        return view.window?.windowScene?.interfaceOrientation ?? .unknown
    }
    
    // Communicate with the session and other session objects on this queue.
    // private let sessionQueue = DispatchQueue(label: "session queue")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up capture image button
        captureImageButton.layer.borderColor = UIColor.gray.cgColor
        captureImageButton.layer.borderWidth = 2
        captureImageButton.layer.cornerRadius = min(captureImageButton.frame.width, captureImageButton.frame.height) / 2
        
        // Check for permissions and initialize the ACCaptureSession if we are ok
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
           // Prevents crashing in the simulator
           let alertController = UIAlertController.init(title: nil, message: "Device has no camera.", preferredStyle: .alert)

           let okAction = UIAlertAction.init(title: "Ok 🥺", style: .default, handler: {(alert: UIAlertAction!) in
           })

           alertController.addAction(okAction)
           self.present(alertController, animated: true, completion: nil)

           return
        }

        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == AVAuthorizationStatus.denied {
           // The system denied access to the camera. Alert the user.
           let alert = UIAlertController(title: "Unable to access the Camera",
                                         message: "To turn on camera access, choose Settings > Privacy > Camera and turn on Camera access for this app.",
                                         preferredStyle: UIAlertController.Style.alert)
           
           let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
           alert.addAction(okAction)
           
           let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
               // Take the user to the Settings app to change permissions.
               guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
               if UIApplication.shared.canOpenURL(settingsUrl) {
                   UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                       // The resource finished opening.
                   })
               }
           })
           alert.addAction(settingsAction)
           
           present(alert, animated: true, completion: nil)
        } else if authStatus == AVAuthorizationStatus.notDetermined {
           AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
               if granted {
                  // self.sessionQueue.async {
                    self.showCameraUsingAV()
                 //  }
               }
           })
        } else {
           //sessionQueue.async {
            self.showCameraUsingAV()
           //}
        }
                       
       let tapToFocusGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapToFocus))
       self.view.addGestureRecognizer(tapToFocusGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if captureSession.isRunning {
            captureSession.stopRunning()
        } else {
            captureSession.startRunning()
        }
    }
}

extension CameraViewController {
    
    func showCameraUsingAV() {
        self.captureDevice = AVCaptureDevice.default(for: .video)
        guard let captureDevice = self.captureDevice else {
            print("Error - No capture device")
            return
        }
        
        // Set up device
        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
        
            // Add input
            if !captureSession.canAddInput(videoDeviceInput) {
                print("Error - Couldn't add video device input to the session")
                return
            }
            
            captureSession.addInput(videoDeviceInput)
            captureSession.sessionPreset = AVCaptureSession.Preset.photo
            captureSession.startRunning()
           
            // display the incoming camera image
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.bounds = view.bounds
            previewLayer.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
            previewLayer.connection?.videoOrientation = .portrait
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

            // display the last dog image
            let previousDogImage = UIImage(named: "test.png")?.cgImage
            let overlayLayer = CALayer()
            overlayLayer.frame = view.bounds
            overlayLayer.contents = previousDogImage
            overlayLayer.opacity = 0.0
            overlayLayer.contentsGravity = CALayerContentsGravity.resizeAspect
            overlayLayer.isGeometryFlipped = true
            
            capturePreviewView.layer.addSublayer(previewLayer)
            capturePreviewView.layer.addSublayer(overlayLayer)
            
            // Set up output
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput?.isHighResolutionCaptureEnabled = true
            self.photoOutput?.maxPhotoQualityPrioritization = .quality
            self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            
            if captureSession.canAddOutput(self.photoOutput!) {
                captureSession.addOutput(self.photoOutput!)
            }
            else {
                print("Error - can't add photoOutput")
            }
        } catch {
             print(error)
             return
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

        // Check if there is any error in capturing
        guard error == nil else {
            print("Fail to capture photo: \(String(describing: error))")
            return
        }
        
        // Check if the pixel buffer could be converted to image data
        guard let imageData = photo.fileDataRepresentation() else {
            print("Fail to convert pixel buffer")
            return
        }
        
        // Check if UIImage could be initialized with image data
        guard let capturedImage = UIImage.init(data: imageData , scale: 1.0) else {
            print("Fail to convert image data to UIImage")
            return
        }

        // Get original image width/height
        let imgWidth = capturedImage.size.width
        let imgHeight = capturedImage.size.height
        // Get origin of cropped image
        let imgOrigin = CGPoint(x: (imgWidth - imgHeight)/2, y: (imgHeight - imgHeight)/2)
        // Get size of cropped iamge
        let imgSize = CGSize(width: imgHeight, height: imgHeight)

        // Check if image could be cropped successfully
        guard let imageRef = capturedImage.cgImage?.cropping(to: CGRect(origin: imgOrigin, size: imgSize)) else {
            print("Fail to crop image")
            return
        }

        // Convert cropped image ref to UIImage
        let imageToSave = UIImage(cgImage: imageRef, scale: 1.0, orientation: .down)
        
        
        // Show thumbnail
        self.currentImage = imageToSave
        self.showImage()
    }
    
    func showImage() {
        let imageReviewViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageReviewViewController") as! ImageReviewViewController
        
        imageReviewViewController.image = self.currentImage
        imageReviewViewController.hidesBottomBarWhenPushed = true

        present(imageReviewViewController, animated: true, completion: nil)
    }
}

extension CameraViewController {
    @objc func tapToFocus(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: recognizer.view)
        let captureDeviceLocation = previewLayer.captureDevicePointConverted(fromLayerPoint: location)
        focus(at: captureDeviceLocation)
    }

    // In your camera controller
    func focus(at point: CGPoint) {
        guard let device = captureDevice else {
            return
        }

        guard device.isFocusPointOfInterestSupported, device.isExposurePointOfInterestSupported else {
            return
        }

        do {
            try device.lockForConfiguration()
            device.focusPointOfInterest = point
            device.exposurePointOfInterest = point

            device.focusMode = .continuousAutoFocus
            device.exposureMode = .continuousAutoExposure

            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
}

extension CameraViewController {
    @IBAction func toggleFlash(_ sender: Any) {
        if flashMode == .on {
           flashMode = .off
           toggleFlashButton.setImage(#imageLiteral(resourceName: "flash_off"), for: .normal)
       }
           
       else {
           flashMode = .on
           toggleFlashButton.setImage(#imageLiteral(resourceName: "flash_on"), for: .normal)
       }
    }
    
    @IBAction func captureImage(_ sender: Any) {
        if !captureSession.isRunning {
            print("Error - Capture session is not running so can't capture image")
        }
           // Set capture settings
           let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
   //        if  self.photoOutput?.availablePhotoCodecTypes.contains(.hevc) ?? false {
   //            photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
   //        }

           photoSettings.isHighResolutionPhotoEnabled = true
           photoSettings.photoQualityPrioritization = .quality
           photoSettings.flashMode = self.flashMode
           
           // Take photo
           self.photoOutput?.capturePhoto(with: photoSettings, delegate: self)
    }
}




// Stop video capturing session (Freeze preview)
//captureSession.stopRunning()
