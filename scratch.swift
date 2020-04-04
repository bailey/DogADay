



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

===============


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
