//
//  ImageTransitionAnimator.swift
//  PhotoBrowser500px
//
//  Created by Crul on 2016-11-21.
//  Copyright © 2016 Sid. All rights reserved.
//

import Foundation
import UIKit

class ImageTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let imageToTransition: UIImageView
    let originalImageFrame: CGRect
    
    init(image: UIImageView, originalFrame: CGRect) {
        self.imageToTransition = image
        self.originalImageFrame = originalFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC: UIViewController = transitionContext.viewController(forKey: .from)!
        let toVC: UIViewController = transitionContext.viewController(forKey: .to)!
        
        let containerView: UIView = transitionContext.containerView
        
        // When presenting: fromView = The presenting view | toView = The presented view
        // When dismissing: fromView = The presented view  | toView = The presenting view
        let fromView: UIView = transitionContext.view(forKey: .from)!
        let toView: UIView = transitionContext.view(forKey: .to)!
        
        fromView.frame = transitionContext.initialFrame(for: fromVC)
        toView.frame = transitionContext.finalFrame(for: toVC)
        
        // If this is a presentation, toViewController corresponds to the presented
        // view controller and its presentingViewController will be
        // fromViewController.  Otherwise, this is a dismissal.
        let isPresenting: Bool = toVC.presentingViewController == fromVC
        let transitionDuration: TimeInterval = self.transitionDuration(using: transitionContext)
        
        if isPresenting {
            self.imageToTransition.alpha = 1.0
            self.imageToTransition.translatesAutoresizingMaskIntoConstraints = false
            
            self.imageToTransition.removeConstraints(self.imageToTransition.constraints)
            let removeConstraints = fromView.constraints.filter({ (constraint: NSLayoutConstraint) -> Bool in
                return constraint.firstItem as? NSObject == self.imageToTransition || constraint.secondItem as? NSObject == self.imageToTransition
            })
            fromView.removeConstraints(removeConstraints)

            
            
            fromView.addConstraint(NSLayoutConstraint(item: self.imageToTransition,
                                                      attribute: .leading,
                                                      relatedBy: .equal,
                                                      toItem: fromView,
                                                      attribute: .leading,
                                                      multiplier: 1.0,
                                                      constant: 0.0))
            fromView.addConstraint(NSLayoutConstraint(item: self.imageToTransition,
                                                      attribute: .trailing,
                                                      relatedBy: .equal,
                                                      toItem: fromView,
                                                      attribute: .trailing,
                                                      multiplier: 1.0,
                                                      constant: 0.0))
            fromView.addConstraint(NSLayoutConstraint(item: self.imageToTransition,
                                                      attribute: .centerY,
                                                      relatedBy: .equal,
                                                      toItem: fromView,
                                                      attribute: .centerY,
                                                      multiplier: 1.0,
                                                      constant: 0.0))
            fromView.addConstraint(NSLayoutConstraint(item: self.imageToTransition,
                                                      attribute: .width,
                                                      relatedBy: .equal,
                                                      toItem: self.imageToTransition,
                                                      attribute: .height,
                                                      multiplier: 1.0,
                                                      constant: 0.0))

            UIView.animate(withDuration: transitionDuration, delay: 0, options: .curveEaseInOut, animations: {
                fromView.layoutIfNeeded()
            }, completion: { (finished: Bool) -> Void in
                // We must explicitly add the incoming view to the containerView
                containerView.addSubview(toView)
                
                // Inform the transition context whether the transition was cancelled or not
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        else {
            // Remove all constraints, we will use frames for positioning here
            self.imageToTransition.removeConstraints(self.imageToTransition.constraints)
            let removeConstraints = toView.constraints.filter({ (constraint: NSLayoutConstraint) -> Bool in
                return constraint.firstItem as? NSObject == self.imageToTransition || constraint.secondItem as? NSObject == self.imageToTransition
            })
            toView.removeConstraints(removeConstraints)
            self.imageToTransition.translatesAutoresizingMaskIntoConstraints = true
            
            // We must explicitly add the incoming view to the containerView
            containerView.addSubview(toView)
            
            UIView.animate(withDuration: transitionDuration, delay: 0, options: .curveEaseInOut, animations: {
                self.imageToTransition.frame = self.originalImageFrame
            }, completion: { (finished: Bool) -> Void in
                self.imageToTransition.alpha = 0.0
                
                // Inform the transition context whether the transition was cancelled or not
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        
    }
}
