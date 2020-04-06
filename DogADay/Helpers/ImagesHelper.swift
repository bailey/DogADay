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
    static var datesCreated : [Date?]?
        
    public static func haveTakenPhotoToday(onSuccess success:@escaping(Bool)->Void,
                                           onFailure failure:@escaping(Error?)->Void)  {
        ImagesHelper.getImages(true, onSuccess: {(images, datesCreated) in
            success(false)
        }) { (error) in
           failure(error)
        }
    }
    
    public static func getImages(_ shouldRefresh: Bool,
                                 onSuccess success:@escaping([UIImage], [Date?])->Void,
                                 onFailure failure:@escaping(Error?)->Void)  {
        // Just return the images if we have them already
        if let images = self.images, let datesCreated = self.datesCreated {
            if !shouldRefresh {
                success(images, datesCreated)
                return
            }
        }
        
        // Refresh the images
        SDPhotosHelper.getImages(fromAlbum: Constants.albumName, onSuccess: {(images, datesCreated) in
            self.images = images
            self.datesCreated = datesCreated
            success(images, datesCreated)
         ImagesHelper.images = images
        }) { (error) in
            failure(error)
        }}
    }
