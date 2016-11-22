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
    static let TAG_LABEL_NAME = 2
    static let TAG_LABEL_VIEW_COUNT = 3
    static let TAG_LABEL_VOTE_COUNT = 4
    
    // MARK: - Public Members
    var detailImage: UIImage? = nil
    var detailImageInfo: Image500px? = nil
    var delegate: ImageDetailViewControllerDelegate? = nil
    
    // MARK: - Event Handlers
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.delegate?.willDismissDetailVC()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        let shareText = ["https://500px.com/photos/\(self.detailImageInfo?.id)"]
        let activityViewController = UIActivityViewController(activityItems: shareText, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // TODO: does iPad crash without this?
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let imageView = self.view.viewWithTag(ImageDetailViewController.TAG_CATEGORY_IMAGE) {
            (imageView as! UIImageView).image = detailImage
        }
        
        if let nameLabel = self.view.viewWithTag(ImageDetailViewController.TAG_LABEL_NAME) {
            let label = nameLabel as! UILabel
            label.numberOfLines = 2
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.contentScaleFactor = 0.8
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let nameLabel = self.view.viewWithTag(ImageDetailViewController.TAG_LABEL_NAME) {
            (nameLabel as! UILabel).text = self.detailImageInfo?.name
        }

        if let viewCountLabel = self.view.viewWithTag(ImageDetailViewController.TAG_LABEL_VIEW_COUNT) {
            if let timesViewed = self.detailImageInfo?.timesViewed {
                (viewCountLabel as! UILabel).text = "\(timesViewed) views"
            }
            else {
                (viewCountLabel as! UILabel).text = "Unknown views"
            }
        }
        
        if let voteCountLabel = self.view.viewWithTag(ImageDetailViewController.TAG_LABEL_VOTE_COUNT) {
            if let votesCount = self.detailImageInfo?.votesCount{
                (voteCountLabel as! UILabel).text = "\(votesCount) votes"
            }
            else {
                (voteCountLabel as! UILabel).text = "Unknown votes"
            }
        }
    }
}
