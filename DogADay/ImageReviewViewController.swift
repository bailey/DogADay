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
    var onDoneBlock : ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        imageView.contentMode = .scaleAspectFill
        if let image = image {
            imageView.image = image
        }
        else {
            print("Error - We didn't get an image to present")
            onDoneBlock?(false)
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        // Save to album
        if let image = image {
            SDPhotosHelper.addNewImage(image, toAlbum: Constants.albumName, onSuccess: { ( identifier) in
                print("Saved image successfully, identifier is \(identifier)")
                ImagesHelper.shouldReload = true
                DispatchQueue.global(qos: .background).async {
                    ImagesHelper.reloadImages()
                }
                }) { (error) in
                   if let error = error {
                       print("Error in creating album : \(error.localizedDescription)")
                   }
                }
        }
        
        // Dismiss
        onDoneBlock?(true)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
