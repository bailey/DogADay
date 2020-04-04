//
//  SecondViewController.swift
//  DogADay
//
//  Created by Bailey Brooks on 4/1/20.
//  Copyright © 2020 Bailey Brooks. All rights reserved.
//

// PhotoPicker sample for use in the authorization code below
//Copyright © 2019 Apple Inc.
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import UIKit
import AVFoundation
import MobileCoreServices

class CameraViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var toggleFlashButton: UIButton!
    @IBOutlet weak var captureImageButton: UIButton!
    @IBOutlet weak var capturePreviewView: UIView!
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    
    var photoOutput: AVCapturePhotoOutput?
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?

    var flashMode = AVCaptureDevice.FlashMode.off
    
    // Communicate with the session and other session objects on this queue.
    // private let sessionQueue = DispatchQueue(label: "session queue")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureImageButton.layer.borderColor = UIColor.black.cgColor
        captureImageButton.layer.borderWidth = 2

        captureImageButton.layer.cornerRadius = min(captureImageButton.frame.width, captureImageButton.frame.height) / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
            
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
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
    }
    
    func showCameraUsingAV() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Error - No capture device")
            return
        }
        
        do {
          captureSession.addInput(try AVCaptureDeviceInput(device: captureDevice))
        } catch {
          print(error)
        }
        
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        captureSession.startRunning()
        stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecType.jpeg]
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
        
        // display the incoming camera image
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.bounds = view.bounds
        previewLayer.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

        //        view.layer.insertSublayer(self.previewLayer!, at: 0) ??
        //        self.previewLayer?.frame = view.frame ??

        
        // display the last dog image
        let previousDogImage = UIImage(named: "test.png")?.cgImage
        let overlayLayer = CALayer()
        overlayLayer.frame = view.bounds
        overlayLayer.contents = previousDogImage
        overlayLayer.opacity = 0.3
        overlayLayer.contentsGravity = CALayerContentsGravity.resizeAspect
        overlayLayer.isGeometryFlipped = true
        
        // Create the UIView
        //let cameraPreview = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width, height: view.bounds.size.height))
        capturePreviewView.layer.addSublayer(previewLayer)
        capturePreviewView.layer.addSublayer(overlayLayer)
        
        //view.addSubview(cameraPreview)
//        view.layer.insertSublayer(<#T##layer: CALayer##CALayer#>, at: <#T##UInt32#>)
//        view.layer.insertSublayer(cameraPreview, at: 0)
//        self.cameraPreview.frame = view.frame
        
        // Set up output
        self.photoOutput = AVCapturePhotoOutput()
        self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
        
        if captureSession.canAddOutput(self.photoOutput!) {
            captureSession.addOutput(self.photoOutput!)
        }
    }
    
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        if !captureSession.isRunning {
            completion(nil, CameraViewControllerError.captureSessionIsMissing);
            return
        }
        
        let settings = AVCapturePhotoSettings() // AVCapturePhotoSettings.init(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        settings.flashMode = self.flashMode
        
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
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
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)

        // Stop video capturing session (Freeze preview)
        captureSession.stopRunning()
    }
    
//    public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
//                        resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
//
//        if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
//
//        else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
//            let image = UIImage(data: data) {
//
//            self.photoCaptureCompletionBlock?(image, nil)
//        }
//
//        else {
//            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
//        }
//    }
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
        captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            
//            try? PHPhotoLibrary.shared().performChangesAndWait {
//                PHAssetChangeRequest.creationRequestForAsset(from: image)
//            }
        }
    }
}

extension CameraViewController {
    enum CameraViewControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
}
