//
//  ImageCollectionViewController.swift
//  PhotoBrowser500px
//
//  Created by Crul on 2016-11-20.
//  Copyright © 2016 Sid. All rights reserved.
//

import UIKit

class ImageCollectionViewController: UICollectionViewController, ImageDetailViewControllerDelegate {
    
    // MARK: - Constants
    static let SEGUE_ID_IMAGE_DETAIL = "imageDetailSegue"
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
    
    private var shouldReloadImageResults = true
    private var imageToTransition: UIImageView? = nil
    
    lazy private var customTransitionDelegate: ImageTransitionDelegate = {
        return ImageTransitionDelegate(image: self.imageToTransition!)
    }()
    
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
        let maxRows = sizeWithSectionInset.height / itemSize.height
        let maxCols = sizeWithSectionInset.width / itemSize.width
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
                else {
                    //debugPrint("Cell not found for path \(retrievedImageIndexPath)")
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
    
    private func loadDataAsync(isLoadMoreAction: Bool = false) {
        if isLoadMoreAction || self.shouldReloadImageResults
        {
            debugPrint("Getting \(self.fetchCount) photos")
            
            API500px.getPhotos(withFeature: self.feature, withCategories: [self.category],
                               withResultCount: self.fetchCount, completionHandler: { (response: API500px.APIImageResponse) in
                                if let error = response.error {
                                    // error - show UI with the ability to refresh
                                    // TODO
                                }
                                else if let result = response.images {
                                    if isLoadMoreAction {
                                        let oldResults = self.imageResults
                                        let newResults = result
                                        let oldNewResults = oldResults + newResults
                                        
                                        self.imageResults = oldNewResults
                                        
                                        let oldResultsCount = oldResults.count
                                        let insertIndexPaths = newResults.enumerated().map({ (index: Int, imageInfo: Image500px) -> IndexPath in
                                            return IndexPath(row: oldResultsCount + index, section: 0)
                                        })

                                        self.collectionView?.insertItems(at: insertIndexPaths)
                                    }
                                    else {
                                        self.imageResults = result
                                        self.collectionView?.reloadData()
                                    }
                                }
                                else {
                                    // response was nil - show UI with the ability to refresh
                                    // TODO
                                }
            })
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.category == .notSet
            ? self.feature.description.replacingOccurrences(of: "_", with: " ").capitalized
            : self.category.description
        
        // self.imageToTransition is the image we will use to animate the image that the user taps
        // We can't directly use the images stored in the collectionView due to clipsToBounds not working
        // Thus, we create this hidden view that will hold and subsequently animate the image that the user
        // taps on.
        let image = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
        image.alpha = 0.0
        self.view.addSubview(image)
        self.imageToTransition = image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.recalculateItemSize(inBoundingSize: self.view.bounds.size)
        self.loadDataAsync()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.shouldReloadImageResults = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.recalculateItemSize(inBoundingSize: size)
        if view.window == nil {
            view.frame = CGRect(origin: view.frame.origin, size: size)
            view.layoutIfNeeded()
        } else {
            coordinator.animate(alongsideTransition: { ctx in
                self.collectionView?.layoutIfNeeded()
            }, completion: nil)
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
        
        // Get image view
        var imageView: UIImageView? = nil
        if let cellImageView = cell.viewWithTag(ImageCollectionViewController.TAG_CELL_IMAGE) {
            if cellImageView is UIImageView {
                imageView = (cellImageView as! UIImageView)
                imageView?.image = nil
            }
        }
        
        let image500px = self.imageResults[indexPath.row]
        // prepopulate with default
        imageView?.image = UIImage(named: "defaultImage")
        
        // fetch image
        self.imageFetcher.fetchImage(urlString: image500px.imageURL, tag: indexPath, completionHandler: { (response: ImageFetcher.ImageFetcherResponse) in
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
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Get image view
        var imageView: UIImageView? = nil
        
        if let cellImageView = cell.viewWithTag(ImageCollectionViewController.TAG_CELL_IMAGE) {
            if cellImageView is UIImageView {
                imageView = (cellImageView as! UIImageView)
                
                let image500px = self.imageResults[indexPath.row]
                // use cache if possible
                if let cachedImage = self.imageFetcher.cache[URL(string:image500px.imageURL)!] {
                    imageView?.image = cachedImage
                }
            }
        }
        
        if indexPath.item == (self.imageResults.count-1) {
            debugPrint("!!!!!!LOAD MORE DATA!!!!!")
            self.loadDataAsync(isLoadMoreAction: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            if let imageView = self.imageView(withCell: cell) {
                self.imageToTransition?.image = imageView.image
                // convert to the coordinate system used by the superview of self.imageToTransition, which is self.view
                self.imageToTransition?.frame = self.view.convert(collectionView.layoutAttributesForItem(at: indexPath)!.frame, from: self.collectionView)
                
                self.performSegue(withIdentifier: ImageCollectionViewController.SEGUE_ID_IMAGE_DETAIL, sender: indexPath)
            }
        }
    }
    
    // MARK: ImageDetailViewControllerDelegate
    
    internal func willDismissDetailVC() {
        self.shouldReloadImageResults = false
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        let destVC = segue.destination
        if segue.identifier == ImageCollectionViewController.SEGUE_ID_IMAGE_DETAIL {
            let transitionDelegate = self.customTransitionDelegate
            transitionDelegate.imageToTransition = self.imageToTransition!
            destVC.transitioningDelegate = transitionDelegate
            destVC.modalPresentationStyle = .fullScreen
            
            if destVC is ImageDetailViewController {
                let detailDestVC = destVC as! ImageDetailViewController
                detailDestVC.imageFetcher = self.imageFetcher
                detailDestVC.imageResults = self.imageResults
                detailDestVC.detailImage = self.imageToTransition?.image
                detailDestVC.delegate = self
        
                if sender is IndexPath {
                    let indexPath = sender as! IndexPath
                    detailDestVC.detailImageIndex = indexPath.row
                }
            }
        }
    }
}
