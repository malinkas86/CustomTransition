//
//  PopAnimator.swift
//  CustomTransiotion
//
//  Created by Malinka S on 4/19/18.
//  Copyright © 2018 Malinka. All rights reserved.
//

import UIKit

final class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning, Animator {

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

            containerView.addSubview(toView)
            containerView.bringSubview(toFront: secondView)

            var fromYValue: CGFloat = 0
            var toYValue: CGFloat = -secondView.frame.height
            if presenting {
                fromYValue = -secondView.frame.height
                toYValue = 0
            }
            
            secondView.frame = CGRect(x: 0, y: fromYValue, width: secondView.frame.width, height: secondView.frame.height)
            UIView.animate(withDuration: duration, animations: {
                secondView.frame = CGRect(x: 0, y: toYValue, width: secondView.frame.width, height: secondView.frame.height)
            }, completion: { _ in
                if !self.presenting {
                    self.dismissCompletion?()
                }
                transitionContext.completeTransition(true)
            })
        }
    }


}
