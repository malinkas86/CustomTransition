//
//  PopAnimator.swift
//  CustomTransiotion
//
//  Created by Malinka S on 4/18/18.
//  Copyright © 2018 Malinka. All rights reserved.
//

import UIKit

final class ScaleAnimator: NSObject, UIViewControllerAnimatedTransitioning, Animator {

    let duration = 1.0
    var presenting = true
    var originFrame = CGRect.zero
    var dismissCompletion: (()->Void)?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        if let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from) {
            let secondView = presenting ? toView : fromView
            let initialFrame = presenting ? originFrame : secondView.frame
            let finalFrame = presenting ? secondView.frame : originFrame

            let xScaleFactor = presenting ?
                initialFrame.width / finalFrame.width :
                finalFrame.width / initialFrame.width

            let yScaleFactor = presenting ?
                initialFrame.height / finalFrame.height :
                finalFrame.height / initialFrame.height

            let scaleTransform = CGAffineTransform(scaleX: xScaleFactor,
                                                   y: yScaleFactor)

            if presenting {
                secondView.transform = scaleTransform
                secondView.center = CGPoint(
                    x: initialFrame.midX,
                    y: initialFrame.midY)
                secondView.clipsToBounds = true
            }

            containerView.addSubview(toView)
            containerView.bringSubview(toFront: secondView)

            UIView.animate(withDuration: duration, delay:0.0,
                           usingSpringWithDamping: 0.4 , initialSpringVelocity: 0.0,
                           animations: {
                            secondView.transform = self.presenting ?
                                CGAffineTransform.identity : scaleTransform
                            secondView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            },
                           completion: { _ in
                            if !self.presenting {
                                self.dismissCompletion?()
                            }
                            transitionContext.completeTransition(true)
            })
        }
    }

}
