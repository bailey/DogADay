//
//  PhotoAlbumHelper.swift
//  DogADay
//
//  Created by Julian Paris Morgan on 4/4/20.
//  Copyright © 2020 Bailey Brooks. All rights reserved.
//

import Foundation
import UIKit

class ImagesHelper {
    static var images : [UIImage]?
        
    public static func haveTakenPhotoToday(onSuccess success:@escaping(Bool)->Void,
                                           onFailure failure:@escaping(Error?)->Void)  {
        ImagesHelper.getImages(true, onSuccess: {(images) in
            success(false)
        }) { (error) in
           failure(error)
        }
    }
    
    public static func getImages(_ shouldRefresh: Bool,
                                 onSuccess success:@escaping([UIImage])->Void,
                                 onFailure failure:@escaping(Error?)->Void)  {
        // Just return the images if we have them already
        if let images = self.images {
            if !shouldRefresh {
                success(images)
                return
            }
        }
        
        // Refresh the images
        SDPhotosHelper.getImages(fromAlbum: Constants.albumName, onSuccess: {(images) in
            self.images = images
            success(images)
         ImagesHelper.images = images
        }) { (error) in
            failure(error)
        }}
    }
