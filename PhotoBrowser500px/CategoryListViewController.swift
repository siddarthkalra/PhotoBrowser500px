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
    
    static let SECTION_FEATURES = 0
    static let SECTION_CATEGORIES = 1
    static let TAG_CATEGORY_IMAGE = 1
    static let TAG_CATEGORY_LABEL = 2
    
    // MARK: - Public Members
    
    var features: [API500px.Feature] = API500px.Feature.allCases
    var categories: [API500px.Category] = API500px.Category.allCases
    
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

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.features.first == .notSet {
           self.features.remove(at: 0)
        }
        if self.categories.first == .notSet {
            self.categories.remove(at: 0)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
            
            if let label = cell?.viewWithTag(CategoryListViewController.TAG_CATEGORY_LABEL) {
                (label as! UILabel).text = self.categories[indexPath.row].description
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
            return 80.0
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
