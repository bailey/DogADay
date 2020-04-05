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

    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 50.0,
       left: 10.0,
       bottom: 10.0,
       right: 10.0)
        
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: self.collectionView.bounds.width, height: 120)
        }
        
        // Save to album
        //SDPhotosHelper.createAlbum(withTitle: <#T##String#>, onResult: <#T##(Bool, Error?) -> Void#>)
        
       
        
        // Save to album
//        SDPhotosHelper.addNewImage(imageToSave, toAlbum: Constants.albumName, onSuccess: { ( identifier) in
//               print("Saved image successfully, identifier is \(identifier)")
//               let alert = UIAlertController.init(title: "Success", message: "Image added, id : \(identifier)", preferredStyle: .alert)
//               let actionOk = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
//               alert.addAction(actionOk)
//               OperationQueue.main.addOperation({
//                   self.present(alert, animated: true, completion: nil)
//               })
//           }) { (error) in
//               if let error = error {
//                   print("Error in creating album : \(error.localizedDescription)")
//               }
           }
    }


// MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCell
        cell.backgroundColor = .blue
       // cell.textLabel.text = String(indexPath.row + 1)
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

extension PhotosViewController {
    @IBAction func createVideoButtonClicked(_ sender: UIButton) {
        print("createVideoButtonClicked")
//        https://stackoverflow.com/questions/40883784/build-video-from-uiimage-using-swift
    }
}

