//
//  CategoryListViewController.swift
//  PhotoBrowser500px
//
//  Created by Crul on 2016-11-20.
//  Copyright © 2016 Sid. All rights reserved.
//

import UIKit

class CategoryListViewController: UITableViewController {

    // MARK: - Constants
    
    static let SEGUE_ID = "imageCollectionSegue"
    static let CELL_ID_FEATURE = "featureCell"
    static let CELL_ID_CATEGORY = "categoryCell"
    
    static let SECTION_COUNT = 2
    static let SECTION_FEATURES = 0
    static let SECTION_CATEGORIES = 1
    static let TAG_CATEGORY_IMAGE = 1
    static let TAG_CATEGORY_LABEL = 2
    static let CELL_HEIGHT_CATEGORY: CGFloat = 80.0
    
    // MARK: - Public Members
    
    var features: [API500px.Feature] = API500px.Feature.allCases
    var categories: [API500px.Category] = API500px.Category.allCases
    var categoryImages: [API500px.Category: Image500px] = [:]
    let imageFetcher = ImageFetcher()
    
    // MARK: - Private Members
    
    private func imageView(withCell cell: UITableViewCell, tag: Int) -> UIImageView? {
        let cellSubviewOptional = cell.viewWithTag(tag)
        
        if let cellSubview = cellSubviewOptional {
            return cellSubview as? UIImageView
        }
        else {
            return nil
        }
    }
    
    private func setupImageView(in tableView: UITableView, image: UIImage?, imageFetcherTag: Any?) {
        if let retrievedImageIndexPath = imageFetcherTag
        {
            if retrievedImageIndexPath is IndexPath {
                if let retrievedCell = tableView.cellForRow(at: retrievedImageIndexPath as! IndexPath) {
                    if let imageView = self.imageView(withCell: retrievedCell, tag: CategoryListViewController.TAG_CATEGORY_IMAGE) {
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
        
        if self.features.first == .notSet {
           self.features.remove(at: 0)
        }
        if self.categories.first == .notSet {
            self.categories.remove(at: 0)
        }

        let getPhotoDispatchGroup = DispatchGroup()
        for category in self.categories
        {
            // I tried to send out a request that included all categories but the API wouldn't return a result that
            // included at least one image from each category so instead, I'm sending 1 request per category
            getPhotoDispatchGroup.enter()
            API500px.getPhotos(withFeature: .popular, withCategories: [category],
                               withSize: .twoHundred, withResultCount: 1,
                               completionHandler: { (response: API500px.APIImageResponse) -> Void in
                getPhotoDispatchGroup.leave()
                                
                if let error = response.error {
                    // error - show UI with the ability to refresh
                    // TODO
                }
                else if let result = response.images {
                    for imageResult in result {
                        if self.categoryImages[imageResult.category] == nil {
                            self.categoryImages[imageResult.category] = imageResult
                        }
                        break
                    }
                }
                else {
                    // response was nil - show UI with the ability to refresh
                    // TODO
                }
            })
        }
        
        getPhotoDispatchGroup.notify(queue: .main, execute: {
            self.tableView.reloadSections(IndexSet(integer: CategoryListViewController.SECTION_CATEGORIES), with: .automatic)
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return CategoryListViewController.SECTION_COUNT
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case CategoryListViewController.SECTION_FEATURES:
            return self.features.count
        case CategoryListViewController.SECTION_CATEGORIES:
            return self.categories.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell?

        switch indexPath.section {
        case CategoryListViewController.SECTION_FEATURES:
            cell = tableView.dequeueReusableCell(withIdentifier: CategoryListViewController.CELL_ID_FEATURE, for: indexPath)
            
            var featureDescription = self.features[indexPath.row].description
            featureDescription = featureDescription.replacingOccurrences(of: "_", with: " ").capitalized
            cell?.textLabel?.text = featureDescription
            break
        case CategoryListViewController.SECTION_CATEGORIES:
            cell = tableView.dequeueReusableCell(withIdentifier: CategoryListViewController.CELL_ID_CATEGORY, for: indexPath)
            
            let thumbnail = self.imageView(withCell: cell!, tag: CategoryListViewController.TAG_CATEGORY_IMAGE)
            thumbnail?.image = UIImage(named: "defaultImage")
            thumbnail?.layer.cornerRadius = (thumbnail?.frame.size.width)! / 2.0;
            thumbnail?.layer.masksToBounds = true;
            
            let category: API500px.Category = self.categories[indexPath.row]
            if let label = cell?.viewWithTag(CategoryListViewController.TAG_CATEGORY_LABEL) {
                (label as! UILabel).text = category.description
            }
            
            if let categoryImage500px = self.categoryImages[category] {
                imageFetcher.fetchImage(urlString: categoryImage500px.imageURL, tag: indexPath, completionHandler: { (response: ImageFetcher.ImageFetcherResponse) in
                    if let error = response.error {
                        // failure
                        debugPrint("error in retrieving image: \(error)")
                    }
                    else {
                        self.setupImageView(in: tableView, image: response.image, imageFetcherTag: response.tag)
                    }
                })
            }
            
            break
        default:
            cell = nil
            break
        }

        return cell!
    }
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: CategoryListViewController.SEGUE_ID, sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case CategoryListViewController.SECTION_FEATURES:
            return "Features"
        case CategoryListViewController.SECTION_CATEGORIES:
            return "Categories"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case CategoryListViewController.SECTION_CATEGORIES:
            return CategoryListViewController.CELL_HEIGHT_CATEGORY
        default:
            return tableView.rowHeight
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destVC = segue.destination
        if segue.identifier == CategoryListViewController.SEGUE_ID {
            if destVC is ImageCollectionViewController {
                let imageCollectionVC = destVC as! ImageCollectionViewController
                if sender is IndexPath {
                    let indexPath: IndexPath = sender as! IndexPath
                    
                    switch indexPath.section {
                    case CategoryListViewController.SECTION_FEATURES:
                        imageCollectionVC.feature = self.features[indexPath.row]
                        break
                    case CategoryListViewController.SECTION_CATEGORIES:
                        imageCollectionVC.category = self.categories[indexPath.row]
                        break
                    default:
                        break
                    }
                }
            }
        }
    }

}
