//
//  ImageCollectionViewController.swift
//  PhotoBrowser500px
//
//  Created by Crul on 2016-11-20.
//  Copyright © 2016 Sid. All rights reserved.
//

import UIKit

class ImageCollectionViewController: UICollectionViewController {
    
    // MARK: - Constants
    static let CELL_ID = "imageCell"
    static let TAG_CELL_IMAGE = 1

    // MARK: - Public Members
    
    let imageResults: [Image500px] = []
    let imageFetcher = ImageFetcher()
    
    // MARK: - Private Members
    
    private var flowLayout: UICollectionViewFlowLayout {
        return collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    // MARK: - Private Methods
    
    private func imageView(withCell cell: UICollectionViewCell) -> UIImageView? {
        let cellSubviewOptional = cell.viewWithTag(ImageCollectionViewController.TAG_CELL_IMAGE)
        
        if let cellSubview = cellSubviewOptional {
            return cellSubview as? UIImageView
        }
        else {
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageResults.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewController.CELL_ID, for: indexPath)
    
        
            let image500px = self.imageResults[indexPath.row]
                imageFetcher.fetchImage(urlString: image500px.imageURL, tag: indexPath, completionHandler: { (response: ImageFetcher.ImageFetcherResponse) in
                    if let error = response.error {
                        // failure
                        // TODO show error to user?
                        debugPrint("error in retrieving image: \(error)")
                    }
                    else {
                        if let retrievedImageIndexPath = response.tag
                        {
                            if retrievedImageIndexPath is IndexPath {    
                                if let retrievedCell = collectionView.cellForItem(at: retrievedImageIndexPath as! IndexPath) {
                                    if let imageView = self.imageView(withCell: retrievedCell) {
                                        imageView.image = response.image
                                    }
                                    else {
                                        debugPrint("Image view not found in cell")
                                    }
                                }
                            }
                            else {
                                debugPrint("Tag is not an index path")
                            }
                        }
                        else {
                            debugPrint("Tag is nil")
                        }
                    }
                })
    
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
}
