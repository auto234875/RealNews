//
//  CustomSegue.swift
//  Real News
//
//  Created by John Smith on 1/12/17.
//  Copyright © 2017 John Smith. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

enum TransitionType {
    case Presenting, Dismissing
}

class SplitFadeAnimator:NSObject,UIViewControllerAnimatedTransitioning{
    var duration:TimeInterval!
    var presenting:Bool!
    var originFrame:CGRect!
    
    init(withDuration duration: TimeInterval, forTransitionType type: TransitionType, originFrame: CGRect) {
        super.init()
        self.duration = duration
        self.presenting = type == .Presenting ? true : false
        self.originFrame = originFrame
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.viewController(forKey: .to)!.view!
        let fromView = transitionContext.viewController(forKey: .from)!.view!
        let scale = UIScreen.main.scale
        if presenting{
            toView.frame = fromView.frame
            containerView.addSubview(toView)
            let image = fromView.snapshot()
            let topView = UIView()
            let middleView = UIView()
            let bottomView = UIView()
            topView.tag = 1
            middleView.tag = 2
            bottomView.tag = 3
            toView.addSubview(topView)
            toView.addSubview(middleView)
            toView.addSubview(bottomView)
            
            if originFrame.origin.y <= 0{
                let images = split_image(image, atDistance: originFrame.origin.y+originFrame.height, edge: .minYEdge,scale:scale)
            middleView.layer.contents = images.0
            bottomView.layer.contents = images.1
            let frames = fromView.frame.divided(atDistance: originFrame.height+originFrame.origin.y, from: .minYEdge)
            middleView.frame = frames.slice
            bottomView.frame = frames.remainder
            }else{
                
                let images = split_image(image, atDistance: originFrame.origin.y, edge: .minYEdge,scale:scale)
                topView.layer.contents = images.0
                let remainder = split_image(UIImage.init(cgImage: images.1), atDistance: originFrame.height, edge: .minYEdge,scale:scale)
                middleView.layer.contents = remainder.0
                bottomView.layer.contents = remainder.1
                let frames = fromView.frame.divided(atDistance: originFrame.origin.y, from: .minYEdge)
                topView.frame = frames.slice
                let remainderFrames = frames.remainder.divided(atDistance: originFrame.height, from: .minYEdge)
                middleView.frame = remainderFrames.slice
                bottomView.frame = remainderFrames.remainder
            }
            
            
        
            UIView.animate(withDuration: duration, delay: 0, options:.curveEaseOut,animations: {
            topView.layer.setAffineTransform(CGAffineTransform.identity.translatedBy(x: 0, y: -topView.frame.height))
            bottomView.layer.setAffineTransform(CGAffineTransform.identity.translatedBy(x: 0, y: bottomView.frame.height))
            middleView.alpha = 0
            }, completion: {complete in
            transitionContext.completeTransition(true)
            })
        }else{
            let topView = fromView.viewWithTag(1)!
            let middleView = fromView.viewWithTag(2)!
            let bottomView = fromView.viewWithTag(3)!
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                topView.layer.setAffineTransform(CGAffineTransform.identity)
                bottomView.layer.setAffineTransform(CGAffineTransform.identity)
                middleView.alpha = 1
            }, completion: {complete in
                 topView.removeFromSuperview()
                 bottomView.removeFromSuperview()
                 middleView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
}


