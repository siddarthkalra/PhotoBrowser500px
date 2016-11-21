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
    static let CELL_ID = "featureCategoryCell"
    static let SECTION_FEATURES = 0
    static let SECTION_CATEGORIES = 1
    
    // MARK: - Public Members
    
    var features: [API500px.Feature] = API500px.Feature.allCases
    var categories: [API500px.Category] = API500px.Category.allCases
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryListViewController.CELL_ID, for: indexPath)

        switch indexPath.section {
        case CategoryListViewController.SECTION_FEATURES:
            var featureDescription = self.features[indexPath.row].description
            featureDescription = featureDescription.replacingOccurrences(of: "_", with: " ").capitalized
            cell.textLabel?.text = featureDescription
            break
        case CategoryListViewController.SECTION_CATEGORIES:
            cell.textLabel?.text = self.categories[indexPath.row].description
            break
        default:
            break
        }

        return cell
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
