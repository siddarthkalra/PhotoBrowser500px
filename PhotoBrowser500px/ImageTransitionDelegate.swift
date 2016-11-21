//
//  ImageTransitionDelegate.swift
//  PhotoBrowser500px
//
//  Created by Crul on 2016-11-21.
//  Copyright © 2016 Sid. All rights reserved.
//

import Foundation
import UIKit

// Provides an instance of ImageTransitionAnimator
class ImageTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var imageToTransition: UIImageView {
        didSet {
            self.originalImageFrame = self.imageToTransition.frame
        }
    }
    var originalImageFrame: CGRect
    
    init(image: UIImageView) {
        self.imageToTransition = image
        self.originalImageFrame = self.imageToTransition.frame
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageTransitionAnimator(image: self.imageToTransition, originalFrame: self.originalImageFrame)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageTransitionAnimator(image: self.imageToTransition, originalFrame: self.originalImageFrame)
    }
}
