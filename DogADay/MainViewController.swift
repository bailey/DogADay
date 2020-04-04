//
//  MainViewController.swift
//  DogADay
//
//  Created by Julian Paris Morgan on 4/3/20.
//  Copyright © 2020 Bailey Brooks. All rights reserved.
//

import UIKit
import Photos

struct Constants {
    static let albumName = "DogADay"
}

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                ()
            })
        }

        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            self.initializeSDPhotosHelper()
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    private func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
            print("Trying again to create the album")
            self.initializeSDPhotosHelper()
        } else {
            print("Error we were unable to create album")
        }
    }
    
    private func initializeSDPhotosHelper() {
        SDPhotosHelper.createAlbum(withTitle: Constants.albumName) { (success, error) in
            if success {
                print("Created album : \(Constants.albumName)")
            } else {
                if let error = error {
                    print("Error in creating album : \(error.localizedDescription)")
                }
            }
        }
    }
}
