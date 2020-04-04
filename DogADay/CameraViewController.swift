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

let CAMERA_TRANSFORM_X : CGFloat = 1
let CAMERA_TRANSFORM_Y : CGFloat = 1.12412


import UIKit
import AVFoundation
import MobileCoreServices

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    var imagePickerController = UIImagePickerController()

    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var error: NSError?
    
    // Communicate with the session and other session objects on this queue.
    private let sessionQueue = DispatchQueue(label: "session queue")

    
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
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == AVAuthorizationStatus.denied {
            // The system denied access to the camera. Alert the user.

            /*
             The user previously denied access to the camera. Tell the user this
             app requires camera access.
            */
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
            /*
             The user never granted or denied permission for media capture with
             the camera. Ask for permission.

             Note: The app must provide a `Privacy - Camera Usage Description`
             key in the Info.plist with a message telling the user why the app
             is requesting access to the device’s camera. See this app's
             Info.plist for such an example usage description.
            */
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if granted {
                   // self.sessionQueue.async {
                        self.showCameraUsingAV()
                  //  }
                }
            })
        } else {
            /*
             The user granted permission to access the camera. Present the
             picker for capture.

             Set the image picker `sourceType` property to
             `UIImagePickerController.SourceType.camera` to configure the picker
             for media capture instead of browsing saved media.
            */
            //sessionQueue.async {
                self.showCameraUsingAV()
            //}
        }
    }
    
    func saveToCamera(sender: UITapGestureRecognizer) {
        
//        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
//            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
//                (imageDataSampleBuffer, error) -> Void in
//                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
//                 UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData), nil, nil, nil)
//            }
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showCameraUsingAV() {
//   https://stackoverflow.com/questions/30329523/ios-positioning-a-custom-overlay-on-camera-vertical-alignment-size-of-top-b
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
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        // display the last dog image
        let previousDogImage = UIImage(named: "test.png")?.cgImage
        let overlayLayer = CALayer()
        overlayLayer.frame = view.bounds
        overlayLayer.contents = previousDogImage
        overlayLayer.opacity = 0.3
        overlayLayer.contentsGravity = CALayerContentsGravity.resizeAspect
        overlayLayer.isGeometryFlipped = true
        
        // Create the UIView
        let cameraPreview = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width, height: view.bounds.size.height))
        
        // Add our layers to the view
        cameraPreview.layer.addSublayer(previewLayer)
        cameraPreview.layer.addSublayer(overlayLayer)
        
        // Set up gesture recognizers
        cameraPreview.addGestureRecognizer(UITapGestureRecognizer(target: self, action:Selector(("saveToCamera:"))))
        
        // Ready to go!
        view.addSubview(cameraPreview)

        
//        self.fullScreenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//        self.fullScreenImageView.contentMode = UIViewContentModeScaleAspectFit;
//        [self.fullScreenImageView setCenter:self.view.center];
        
//            AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
//            captureSession.sessionPreset = AVCaptureSessionPresetHigh;
//            AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//            if (captureDevice) {
//                NSError *error;
//                AVCaptureDeviceInput *captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
//                if (!error && [captureSession canAddInput:captureDeviceInput]) {
//                    [captureSession addInput:captureDeviceInput];
//                }
//            }
//
//            AVCaptureStillImageOutput *stillImageOutput = [AVCaptureStillImageOutput new];
//            [stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG,
//                                                  AVVideoQualityKey : @(0.6)}];
//            [captureSession addOutput:stillImageOutput];
//
//            self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
//            [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//            self.previewLayer.frame = self.fullScreenImageView.bounds;
//            self.previewLayer.position = CGPointMake(CGRectGetMidX(self.fullScreenImageView.bounds), CGRectGetMidY(self.fullScreenImageView.bounds));
//            [self.fullScreenImageView.layer addSublayer:self.previewLayer];
//            [captureSession startRunning];
//
//            CGRect circleRect = CGRectMake(0, (self.fullScreenImageView.bounds.size.height - self.fullScreenImageView.bounds.size.width) / 2, self.fullScreenImageView.bounds.size.width, self.fullScreenImageView.bounds.size.width);
//            UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:circleRect];
//            CAShapeLayer *ringLayer = [CAShapeLayer layer];
//            ringLayer.path = circle.CGPath;
//            ringLayer.fillColor = nil;
//            ringLayer.strokeColor = [UIColor redColor].CGColor;
//            ringLayer.lineWidth = 2.0;
//            ringLayer.lineDashPattern = @[@5.0, @10.0];
//            [self.fullScreenImageView.layer addSublayer:ringLayer];
//
//            [self.navigationController setToolbarHidden:NO];
//            [self.navigationController.toolbar setBarStyle:UIBarStyleBlackOpaque];
//            [self.navigationController.toolbar setTintColor:[UIColor whiteColor]];
//            // Add here some buttons, which are standard UIBarButtonItems
//
//        [self.view addSubview:self.fullScreenImageView];
//
        
    }
    
//    func showCamera() {
//
//        //        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        //        let overlayView = OverlayView(frame: frame)
//
//                let previousDogImage = UIImage(named: "test.png")
//                let imageOverlayView = UIImageView(image: previousDogImage)
//                imageOverlayView.alpha = 0.5
//                imageOverlayView.contentMode = .scaleAspectFit
//                imageOverlayView.frame = self.view.frame
//
//                //imageOverlayView.frame = imagePickerController.cameraOverlayView!.frame
//
//
//
//                //imageOverlayView.frame = CGRect(x: 0, y: 1, width: (imageOverlayView.image?.size.width)!, height: (imageOverlayView.image?.size.height)!)
//
//
//                imagePickerController.delegate = self
//                imagePickerController.allowsEditing = false
//                imagePickerController.sourceType = .camera
//                //imagePickerController.cameraOverlayView = overlayView
//                imagePickerController.cameraOverlayView = imageOverlayView
//
//
////        imagePickerController.showsCameraControls = false;
////        let screenBounds: CGSize = UIScreen.main.bounds.size;
////        let scale = screenBounds.width / screenBounds.height;
////        imagePickerController.cameraViewTransform = imagePickerController.cameraViewTransform.scaledBy(x: scale, y: scale);
//
//
//       // imagePickerController.cameraViewTransform =
//        //CGAffineTransformScale(imagePickerController.cameraViewTransform,
//               //     CAMERA_TRANSFORM_X,
//               //     CAMERA_TRANSFORM_Y);
//
////    imagePickerController.cameraViewTransform = imagePickerController.cameraViewTransform.scaledBy(x: CAMERA_TRANSFORM_X, y: CAMERA_TRANSFORM_Y)
//
//
//        present(imagePickerController, animated: true, completion: nil)
//
//
//        //        Update re: scaling-- LilMoke, I assume when you say that the image is offset you're getting into trouble with the difference with the camera's aspect ratio (4:3) and the screen of the iPhone (3:4). You can define a constant and use it to set the cameraViewTransform property of your UIImagePickerController. Here's a code snippet, partially borrowed, and simplified from the excellent augmented reality tutorial at raywenderlich.com:
//        //        #define CAMERA_TRANSFORM  1.24299
//                //        imagePicker.cameraViewTransform = CGAffineTransformScale(imagePicker.cameraViewTransform,
//        //        CAMERA_TRANSFORM, CAMERA_TRANSFORM); // If I understood your problem, this should help
//
//
//        //        //hide all controls
//        //        picker.showsCameraControls = NO;
//        //        picker.navigationBarHidden = YES;
//        //        picker.toolbarHidden = YES;
//                //make the video preview full size
//        //        picker.wantsFullScreenLayout = YES;
//        //        picker.cameraViewTransform =
//        //        CGAffineTransformScale(picker.cameraViewTransform,
//        //                               CAMERA_TRANSFORM_X,
//        //                               CAMERA_TRANSFORM_Y);
//        //        //set our custom overlay view
//        //        picker.cameraOverlayView = overlay;
//
//                //show picker
//               // [self presentModalViewController:picker animated:YES];
//
//    }
}

//extension CameraViewController : UIImagePickerControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        imagePicker.dismiss(animated: true, completion: nil)
//        imageView.image = info[.originalImage] as? UIImage
//    }
//}

class ImageOverlayView : UIImageView {
    
//    func create(image: UIImage?, frame: CGRect) {
//
//    }
    
     override init(image: UIImage?) {
        super.init(image: image)

     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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

extension UIViewController{

    func traverseAndFindClass<T : UIViewController>() -> T? {
        var currentVC = self
        while let parentVC = currentVC.parent {
            if let result = parentVC as? T {
                return result
            }
            currentVC = parentVC
        }
        return nil
    }
}



extension PhotosViewController {
    @IBAction func toggleFlash(_ sender: UIButton) {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
        }
            
        else {
            cameraController.flashMode = .on
            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
        }
    }
}
