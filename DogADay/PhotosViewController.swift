//
//  PhotosViewController.swift
//  DogADay
//
//  Created by Julian Paris Morgan on 4/3/20.
//  Copyright © 2020 Bailey Brooks. All rights reserved.
//

import UIKit

// MARK: - ImageCell
class ImageCell: UICollectionViewCell {
    @IBOutlet weak var newImageView: UIImageView!
    @IBOutlet weak var photoDateView: UITextField!
}

// MARK: - PhotosViewController
class PhotosViewController : UIViewController
{
    private let reuseIdentifier = "ImageCell"
    private var images: [UIImage] = []
    private var datesCreated: [Date?] = []
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 20.0,
       left: 10.0,
       bottom: 20.0,
       right: 10.0)
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Don't need to refresh images because
        // 1) MainViewController will do it after checking that the album is created
        // 2) When we take a new image, we will load images immediately after
        ImagesHelper.getImages(onSuccess: {(images, datesCreated) in
            print("Got \(images.count) images")
            self.images = images
            self.datesCreated = datesCreated
            self.collectionView.reloadData()
        }) { (error) in
            if let error = error {
               print("Error in creating album : \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // print("bailey test \(images.count)")
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCell
        cell.contentView.frame = cell.bounds
        cell.backgroundColor = .black
        
        // Set date
        let date = dateFormatter.string(from: datesCreated[indexPath.item]!)
        cell.photoDateView.text = date
        
        // Set image
        cell.newImageView.image = images[indexPath.item]
        cell.newImageView.contentMode = .scaleAspectFill
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item + 1)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosViewController : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}

extension PhotosViewController {
    @IBAction func createVideoButtonClicked(_ sender: UIButton) {
        print("createVideoButtonClicked")
//        https://stackoverflow.com/questions/40883784/build-video-from-uiimage-using-swift
    }
}

