//
//  ImageDetailViewController.swift
//  PhotoBrowser500px
//
//  Created by Crul on 2016-11-21.
//  Copyright © 2016 Sid. All rights reserved.
//

import UIKit

protocol ImageDetailViewControllerDelegate {
    func willDismissDetailVC()
}

class ImageDetailViewController: UIViewController {

    // MARK: - Constants
    
    static let TAG_CATEGORY_IMAGE = 1
    
    // MARK: - Public Members
    var detailImage: UIImage? = nil
    var delegate: ImageDetailViewControllerDelegate? = nil
    
    // MARK: - Event Handlers
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.delegate?.willDismissDetailVC()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let imageView = self.view.viewWithTag(ImageDetailViewController.TAG_CATEGORY_IMAGE) {
            (imageView as! UIImageView).image = detailImage
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let imageView = self.view.viewWithTag(ImageDetailViewController.TAG_CATEGORY_IMAGE) {
            debugPrint("detail image frame \(imageView.frame)")
        }
        
    }
}
