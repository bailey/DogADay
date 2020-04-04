//
//  LapseViewController.swift
//  DogADay
//
//  Created by Julian Paris Morgan on 4/3/20.
//  Copyright © 2020 Bailey Brooks. All rights reserved.
//

import UIKit

class LapseViewController: UICollectionViewController {

    private let reuseIdentifier = "ImageCell"
    
//    private let sectionInsets = UIEdgeInsets(top: 50.0,
//    left: 20.0,
//    bottom: 50.0,
//    right: 20.0)
    private let sectionInsets = UIEdgeInsets(top: 50.0,
      left: 10.0,
      bottom: 10.0,
      right: 10.0)
    
    private let itemsPerRow: CGFloat = 3

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// MARK: - UICollectionViewDataSource
extension LapseViewController {
  //1
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  //2
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return 20
  }
  
  //3
  override func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    
    //1
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                    for: indexPath) as! ImageCell
      //2
      //let flickrPhoto = photo(for: indexPath)
      cell.backgroundColor = .black
      //3
      //cell.imageView.image = flickrPhoto.thumbnail
        
      return cell
  }
}

// MARK: - Collection View Flow Layout Delegate
extension LapseViewController : UICollectionViewDelegateFlowLayout {
  //1
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    //2
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  //3
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  // 4
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
