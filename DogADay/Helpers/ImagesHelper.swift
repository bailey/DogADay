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
    private static let alwaysReturnNoPhotoToday = true // DEBUG
    
    static var images : [UIImage]?
    static var datesCreated : [Date?]?
    static var shouldReload : Bool = true
    private static var haveTakenPhotoToday : Bool?
    
    public static func haveTakenPhotoToday(onSuccess success:@escaping(Bool)->Void,
                                           onFailure failure:@escaping(Error?)->Void)  {
        if alwaysReturnNoPhotoToday == true {
            success(false)
            return
        }
        if let haveTakenPhotoToday = haveTakenPhotoToday {
            success(haveTakenPhotoToday)
            return
        }
        ImagesHelper.getImages(onSuccess: {(images, datesCreated) in success(false)
            let calendar = Calendar.current
            for date in datesCreated {
                if let date = date, calendar.isDateInToday(date) {
                    print("today at date \(date)!")
                    haveTakenPhotoToday = true
                    success(true)
                    return
                }
                else {
                    // No photo today
                    success(false)
               }
            }
            }) { (error) in
               failure(error)
            }
    }
    
    static func reloadImages() {
        ImagesHelper.getImages(onSuccess: {(images, datesCreated) in
            print("Reloaded - now there are \(images.count) images")
        }) { (error) in
            if let error = error {
                print("Error in loading images: \(error.localizedDescription)")
            }
        }
    }
    
    public static func getImages(onSuccess success:@escaping([UIImage], [Date?])->Void,
                                 onFailure failure:@escaping(Error?)->Void)  {
        // Just return the images if we have them already
        if let images = self.images, let datesCreated = self.datesCreated {
            if !shouldReload {
                success(images, datesCreated)
                return
            }
        }
        
        // Refresh the images
        SDPhotosHelper.getImages(fromAlbum: Constants.albumName, onSuccess: {(images, datesCreated) in
            // Set properties
            self.images = images
            self.datesCreated = datesCreated
            self.shouldReload = false
            
            // Set whether we have a photo from today
            let calendar = Calendar.current
            for date in datesCreated {
                if let date = date, calendar.isDateInToday(date) {
                    print("today at date \(date)!")
                    haveTakenPhotoToday = true
                }
            }
            
            success(images, datesCreated)
         ImagesHelper.images = images
        }) { (error) in
            failure(error)
        }}
    }
