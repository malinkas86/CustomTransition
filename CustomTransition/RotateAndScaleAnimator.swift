//
//  RotateAndScaleAnimator.swift
//  CustomTransiotion
//
//  Created by Malinka S on 4/22/18.
//  Copyright © 2018 Malinka. All rights reserved.
//

import UIKit

final class RotateAndScaleAnimator: NSObject, UIViewControllerAnimatedTransitioning, Animator {

    let duration = 2.0
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

            rotate(view: secondView, duration: duration)

            UIView.animate(withDuration: duration, delay:0.0,
                           usingSpringWithDamping: 0.4 , initialSpringVelocity: 0.0,
                           animations: { [weak self] in
                            secondView.transform = self?.presenting == true ?
                                CGAffineTransform.identity : scaleTransform
                            secondView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            },
                           completion: { [weak self] _ in
                            if self?.presenting == false {
                                self?.dismissCompletion?()
                            }
                            transitionContext.completeTransition(true)
            })
        }
    }

    func rotate(view: UIView, duration: TimeInterval) {
        UIView.animate(withDuration: duration/4,
                       delay: 0.0,
                       options: [.curveLinear], animations: {
                        let angle = Double.pi
                        view.transform = view.transform.rotated(by: CGFloat(angle))
        }, completion: {[weak self] finished in
            if finished &&
                view.transform != CGAffineTransform.identity {
                self?.rotate(view: view, duration: duration)
            }
        })
    }

}
