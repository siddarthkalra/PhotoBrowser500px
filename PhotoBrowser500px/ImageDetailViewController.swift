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

class ImageDetailViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Constants
    
    static let TAG_LABEL_NAME = 2
    static let TAG_LABEL_VIEW_COUNT = 3
    static let TAG_LABEL_VOTE_COUNT = 4
    
    // MARK: - Public Members
    
    var detailImage: UIImage? = nil // image shown first
    var detailImageIndex: Int? = nil
    var delegate: ImageDetailViewControllerDelegate? = nil
    var imageFetcher: ImageFetcher? = nil
    var imageResults: [Image500px]? = nil
    
    // MARK: - Private Members
    
    private var innerScrollViewImages: [UIScrollView: UIImageView] = [:]
    @IBOutlet weak var outerScrollView: UIScrollView!
    
    lazy private var scrollViewTop: NSLayoutConstraint = {
        let topConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.outerScrollView,
                                                                   attribute: .top,
                                                                   relatedBy: .equal,
                                                                   toItem: self.view,
                                                                   attribute: .top,
                                                                   multiplier: 1.0,
                                                                   constant: 0.0)
        
        self.view.addConstraint(topConstraint)
        return topConstraint
    }()
    
    lazy private var scrollViewBottom: NSLayoutConstraint = {
        let bottomConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.outerScrollView,
                                                                      attribute: .bottom,
                                                                      relatedBy: .equal,
                                                                      toItem: self.view,
                                                                      attribute: .bottom,
                                                                      multiplier: 1.0,
                                                                      constant: 0.0)
        
        self.view.addConstraint(bottomConstraint)
        return bottomConstraint
    }()
    
    lazy private var scrollViewCenterX: NSLayoutConstraint = {
        let centerXConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.outerScrollView,
                                                                       attribute: .centerX,
                                                                       relatedBy: .equal,
                                                                       toItem: self.view,
                                                                       attribute: .centerX,
                                                                       multiplier: 1.0,
                                                                       constant: 0.0)
        
        self.view.addConstraint(centerXConstraint)
        return centerXConstraint
    }()
    
    lazy private var scrollViewLeading: NSLayoutConstraint = {
        let leadingConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.outerScrollView,
                                                                       attribute: .leading,
                                                                       relatedBy: .equal,
                                                                       toItem: self.view,
                                                                       attribute: .leading,
                                                                       multiplier: 1.0,
                                                                       constant: 0.0)
        
        self.view.addConstraint(leadingConstraint)
        return leadingConstraint
    }()
    
    lazy private var scrollViewTrailing: NSLayoutConstraint = {
        let trailingConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.outerScrollView,
                                                                        attribute: .trailing,
                                                                        relatedBy: .equal,
                                                                        toItem: self.view,
                                                                        attribute: .trailing,
                                                                        multiplier: 1.0,
                                                                        constant: 0.0)
        
        self.view.addConstraint(trailingConstraint)
        return trailingConstraint
    }()
    
    lazy private var scrollViewCenterY: NSLayoutConstraint = {
        let centerYConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.outerScrollView,
                                                                       attribute: .centerY,
                                                                       relatedBy: .equal,
                                                                       toItem: self.view,
                                                                       attribute: .centerY,
                                                                       multiplier: 1.0,
                                                                       constant: 0.0)
        
        self.view.addConstraint(centerYConstraint)
        return centerYConstraint
    }()
    
    lazy private var scrollViewAspectRatio: NSLayoutConstraint = {
        let aspect: NSLayoutConstraint = NSLayoutConstraint(item: self.outerScrollView,
                                                            attribute: .width,
                                                            relatedBy: .equal,
                                                            toItem: self.outerScrollView,
                                                            attribute: .height,
                                                            multiplier: 1.0,
                                                            constant: 0.0)
        
        self.outerScrollView.addConstraint(aspect)
        return aspect
    }()
    
    // MARK: - Private Methods
    
    private func setupOuterScrollViewConstraints() {
        let orientation = UIApplication.shared.statusBarOrientation
        
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            debugPrint("landscape")
            NSLayoutConstraint.deactivate([self.scrollViewLeading, self.scrollViewTrailing, self.scrollViewCenterY])
            NSLayoutConstraint.activate([self.scrollViewTop, self.scrollViewBottom, self.scrollViewCenterX, self.scrollViewAspectRatio])
            break
        default:
            NSLayoutConstraint.deactivate([self.scrollViewTop, self.scrollViewBottom, self.scrollViewCenterX])
            NSLayoutConstraint.activate([self.scrollViewLeading, self.scrollViewTrailing, self.scrollViewCenterY, self.scrollViewAspectRatio])
            break
        }
    }
    
    private func setupInnerScrollView(outerScrollView: UIScrollView,
                                      image: UIImage,
                                      prevInnerScrollView: UIScrollView? = nil,
                                      isLast: Bool = false) -> (scrollView: UIScrollView, imageView: UIImageView)
    {
        outerScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let innerScrollView = UIScrollView()
        innerScrollView.delegate = self
        innerScrollView.maximumZoomScale = 2.0
        innerScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        outerScrollView.addSubview(innerScrollView)
        
        if let previousInnerScrollView = prevInnerScrollView {
            outerScrollView.addConstraint(NSLayoutConstraint(item: innerScrollView,
                                                             attribute: .leading,
                                                             relatedBy: .equal,
                                                             toItem: previousInnerScrollView,
                                                             attribute: .trailing,
                                                             multiplier: 1.0,
                                                             constant: 0.0))
        }
        else {
            outerScrollView.addConstraint(NSLayoutConstraint(item: innerScrollView,
                                                             attribute: .leading,
                                                             relatedBy: .equal,
                                                             toItem: outerScrollView,
                                                             attribute: .leading,
                                                             multiplier: 1.0,
                                                             constant: 0.0))
        }
        
        if isLast {
            outerScrollView.addConstraint(NSLayoutConstraint(item: innerScrollView,
                                                             attribute: .trailing,
                                                             relatedBy: .equal,
                                                             toItem: outerScrollView,
                                                             attribute: .trailing,
                                                             multiplier: 1.0,
                                                             constant: 0.0))
        }
        
        outerScrollView.addConstraint(NSLayoutConstraint(item: innerScrollView,
                                                         attribute: .centerY,
                                                         relatedBy: .equal,
                                                         toItem: outerScrollView,
                                                         attribute: .centerY,
                                                         multiplier: 1.0,
                                                         constant: 0.0))
        outerScrollView.addConstraint(NSLayoutConstraint(item: innerScrollView,
                                                         attribute: .height,
                                                         relatedBy: .equal,
                                                         toItem: outerScrollView,
                                                         attribute: .height,
                                                         multiplier: 1.0,
                                                         constant: 0.0))
        outerScrollView.addConstraint(NSLayoutConstraint(item: innerScrollView,
                                                         attribute: .width,
                                                         relatedBy: .equal,
                                                         toItem: outerScrollView,
                                                         attribute: .width,
                                                         multiplier: 1.0,
                                                         constant: 0.0))
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        innerScrollView.addSubview(imageView)
        
        innerScrollView.addConstraint(NSLayoutConstraint(item: imageView,
                                                         attribute: .leading,
                                                         relatedBy: .equal,
                                                         toItem: innerScrollView,
                                                         attribute: .leading,
                                                         multiplier: 1.0,
                                                         constant: 0.0))
        innerScrollView.addConstraint(NSLayoutConstraint(item: imageView,
                                                         attribute: .trailing,
                                                         relatedBy: .equal,
                                                         toItem: innerScrollView,
                                                         attribute: .trailing,
                                                         multiplier: 1.0,
                                                         constant: 0.0))
        innerScrollView.addConstraint(NSLayoutConstraint(item: imageView,
                                                         attribute: .centerY,
                                                         relatedBy: .equal,
                                                         toItem: innerScrollView,
                                                         attribute: .centerY,
                                                         multiplier: 1.0,
                                                         constant: 0.0))
        innerScrollView.addConstraint(NSLayoutConstraint(item: imageView,
                                                         attribute: .height,
                                                         relatedBy: .equal,
                                                         toItem: innerScrollView,
                                                         attribute: .height,
                                                         multiplier: 1.0,
                                                         constant: 0.0))
        innerScrollView.addConstraint(NSLayoutConstraint(item: imageView,
                                                         attribute: .width,
                                                         relatedBy: .equal,
                                                         toItem: innerScrollView,
                                                         attribute: .width,
                                                         multiplier: 1.0,
                                                         constant: 0.0))
        return (scrollView: innerScrollView, imageView: imageView)
    }
    
    // MARK: - Event Handlers
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.delegate?.willDismissDetailVC()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        let detailImageInfo: Image500px = (self.imageResults?[self.detailImageIndex!])!
        
        let shareText = ["https://500px.com/photos/\(detailImageInfo.id)"]
        let activityViewController = UIActivityViewController(activityItems: shareText, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // TODO: does iPad crash without this?
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        self.setupOuterScrollViewConstraints()
        
        // setup outer scrollview
        self.outerScrollView.isPagingEnabled = true
        
        let firstInnerScrollViewInfo = self.setupInnerScrollView(outerScrollView: self.outerScrollView, image: self.detailImage!)
        self.innerScrollViewImages[firstInnerScrollViewInfo.scrollView] = firstInnerScrollViewInfo.imageView
        
        let secondDetailImageInfo = self.imageResults?[self.detailImageIndex! + 1]
        if let secondDetailImage = self.imageFetcher?.cache[URL(string: (secondDetailImageInfo?.imageURL)!)!] {
            let secondInnerScrollViewInfo = self.setupInnerScrollView(outerScrollView: self.outerScrollView,
                                                                      image: secondDetailImage,
                                                                      prevInnerScrollView: firstInnerScrollViewInfo.scrollView,
                                                                      isLast: true)
            self.innerScrollViewImages[secondInnerScrollViewInfo.scrollView] = secondInnerScrollViewInfo.imageView
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
        
        let detailImageInfo: Image500px = (self.imageResults?[self.detailImageIndex!])!
        if let nameLabel = self.view.viewWithTag(ImageDetailViewController.TAG_LABEL_NAME) {
            (nameLabel as! UILabel).text = detailImageInfo.name
        }

        if let viewCountLabel = self.view.viewWithTag(ImageDetailViewController.TAG_LABEL_VIEW_COUNT) {
            (viewCountLabel as! UILabel).text = "\(detailImageInfo.timesViewed) views"
        }
        
        if let voteCountLabel = self.view.viewWithTag(ImageDetailViewController.TAG_LABEL_VOTE_COUNT) {
            (voteCountLabel as! UILabel).text = "\(detailImageInfo.votesCount) votes"
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            for scrollView in self.innerScrollViewImages.keys {
                scrollView.zoomScale = 1.0
            }
            
            self.setupOuterScrollViewConstraints()
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            debugPrint("rotation completed")
        })
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.innerScrollViewImages[scrollView]
    }
}
