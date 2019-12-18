//
//  PopAnimator.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 18.12.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import Foundation
import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.3
    var presenting = true
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let productView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        
        let initialFrame = presenting ? originFrame : productView.frame
        let finalFrame = presenting ? productView.frame : originFrame
        
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            productView.transform = scaleTransform
            productView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            productView.clipsToBounds = true
        }
        
        // recipeView.layer.cornerRadius = presenting ? 20.0 : 0.0
        productView.layer.masksToBounds = true
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(productView)
        
        UIView.animate(
            withDuration: duration,
            delay:0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.2,
            animations: {
                productView.transform = self.presenting ? .identity : scaleTransform
                productView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                // recipeView.layer.cornerRadius = !self.presenting ? 20.0 : 0.0
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
     
        
        
    }
}
