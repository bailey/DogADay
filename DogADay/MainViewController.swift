//
//  MainViewController.swift
//  DogADay
//
//  Created by Julian Paris Morgan on 4/3/20.
//  Copyright © 2020 Bailey Brooks. All rights reserved.
//

import UIKit

struct Constants {
    static let albumName = "DogADay"
}

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initializeSDPhotosHelper()
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
