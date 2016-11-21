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
    static let FETCH_COUNT_DEFAULT = 20

    // MARK: - Public Members
    
    var imageResults: [Image500px] = []
    let imageFetcher = ImageFetcher()
    var imageSize: CGSize = CGSize.zero
    var fetchCount: Int = FETCH_COUNT_DEFAULT
    var feature: API500px.Feature = .freshToday
    var category: API500px.Category = .notSet
    
    // MARK: - Private Members
    
    private var flowLayout: UICollectionViewFlowLayout {
        return collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    private func itemSize(inBoundingSize size: CGSize) -> (itemSize: CGSize, lineSpacing: Int) {
        var length = 0
        let w = Int(size.width)
        var spacing = 1
        for i in 1...3 {
            for n in 4...8 {
                let x = w - ((n-1) * i)
                if x % n == 0 && (x/n) > length {
                    length = x/n
                    spacing = i
                }
            }
        }
        
        return (CGSize(width: length, height: length), spacing)
    }
    
    // MARK: - Private Methods
    
    func recalculateItemSize(inBoundingSize size: CGSize) {
        let layout = self.flowLayout
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        let sizeWithSectionInset: CGSize = CGSize(width: size.width - 5, height: size.height - 5)
        
        let itemInfo = self.itemSize(inBoundingSize: sizeWithSectionInset)
        layout.minimumLineSpacing = CGFloat(itemInfo.lineSpacing)
        layout.itemSize = itemInfo.itemSize

        let itemSize = layout.itemSize
        let scale = UIScreen.main.scale
        self.imageSize = CGSize(width: itemSize.width * scale, height: itemSize.height * scale);
        
        // determine the amount of images to fetch according to screen dimensions and itemSize
        let maxRows = sizeWithSectionInset.height / itemInfo.itemSize.height
        let maxCols = sizeWithSectionInset.width / itemInfo.itemSize.width
        self.fetchCount = Int(maxRows * maxCols) + ImageCollectionViewController.FETCH_COUNT_DEFAULT
    }

    private func imageView(withCell cell: UICollectionViewCell) -> UIImageView? {
        let cellSubviewOptional = cell.viewWithTag(ImageCollectionViewController.TAG_CELL_IMAGE)
        
        if let cellSubview = cellSubviewOptional {
            return cellSubview as? UIImageView
        }
        else {
            return nil
        }
    }
    
    private func setupImageView(in collectionView: UICollectionView, image: UIImage?, imageFetcherTag: Any?) {
        if let retrievedImageIndexPath = imageFetcherTag
        {
            if retrievedImageIndexPath is IndexPath {
                if let retrievedCell = collectionView.cellForItem(at: retrievedImageIndexPath as! IndexPath) {
                    if let imageView = self.imageView(withCell: retrievedCell) {
                        imageView.image = image
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
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.recalculateItemSize(inBoundingSize: self.view.bounds.size)
        
        debugPrint("Getting \(self.fetchCount) photos")
        API500px.getPhotos(withFeature: self.feature, withCategory: self.category,
                           withResultCount: self.fetchCount, completionHandler: { (response: API500px.APIImageResponse) in
            if let error = response.error {
                // error - show UI with the ability to refresh
                // TODO
            }
            else if let result = response.images {
                self.imageResults = result
                self.collectionView?.reloadData()
            }
            else {
                // response was nil - show UI with the ability to refresh
                // TODO
            }
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        self.recalculateItemSize(inBoundingSize: size)
        if view.window == nil {
            view.frame = CGRect(origin: view.frame.origin, size: size)
            view.layoutIfNeeded()
        } else {
            let indexPath = self.collectionView?.indexPathsForVisibleItems.last
            coordinator.animate(alongsideTransition: { ctx in
                self.collectionView?.layoutIfNeeded()
            }, completion: { _ in
//                if self.layoutStyle == .oneUp, let indexPath = indexPath {
//                    self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
//                }
            })
        }
        
        super.viewWillTransition(to: size, with: coordinator)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        self.imageFetcher.purgeCache()
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
                self.setupImageView(in: collectionView, image: UIImage(named: "defaultImage"), imageFetcherTag: response.tag)
            }
            else {
                self.setupImageView(in: collectionView, image: response.image, imageFetcherTag: response.tag)
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
