//
//  ImageReviewController.swift
//  DogADay
//
//  Created by Julian Paris Morgan on 4/4/20.
//  Copyright © 2020 Bailey Brooks. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MobileCoreServices

class ImageReviewViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        captureImageButton.layer.borderColor = UIColor.black.cgColor
//        captureImageButton.layer.borderWidth = 2
//
//        captureImageButton.layer.cornerRadius = min(captureImageButton.frame.width, captureImageButton.frame.height) / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        https://stackoverflow.com/questions/28760541/programmatically-go-back-to-previous-viewcontroller-in-swift
        
        if let image = image {
            imageView.image = image
        }
        else {
            print("Error - We didn't get an image to present")
            //retakeButtonTapped(nil)
        }
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        print("Finish!")
        
        // Save to album
        
        if let image = image {
            SDPhotosHelper.addNewImage(image, toAlbum: Constants.albumName, onSuccess: { ( identifier) in
                   print("Saved image successfully, identifier is \(identifier)")
    //               let alert = UIAlertController.init(title: "Success", message: "Image added, id : \(identifier)", preferredStyle: .alert)
    //               let actionOk = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
    //               alert.addAction(actionOk)
    //               OperationQueue.main.addOperation({
    //                   self.present(alert, animated: true, completion: nil)
    //               })
               }) { (error) in
                   if let error = error {
                       print("Error in creating album : \(error.localizedDescription)")
                   }
               }
        }
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func retakeButtonTapped(_ sender: Any) {
//       print("Retake!")
//        _ = navigationController?.popViewController(animated: true)
//    }
}
