////
////  PhotoAlbumHelper.swift
////  DogADay
////
////  Created by Julian Paris Morgan on 4/4/20.
////  Copyright © 2020 Bailey Brooks. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class ImagesHelper {
//    var images : [UIImage]?
//    
//    func getAllImages(_ shouldRefresh: Bool) {
//        if images == nil || shouldRefresh {
//            refreshImages()
//        }
//        
//        return images
//    }
//    
//    private func refreshImages() {
//        SDPhotosHelper.getImages(fromAlbum: Constants.albumName, onSuccess: {(images) in
//               print("Got images")
//               print(images)
//               print(images.count)
//            self.photos = images
//           }) { (error) in
//               if let error = error {
//                   print("Error in creating album : \(error.localizedDescription)")
//               }
//           }}
//    }
