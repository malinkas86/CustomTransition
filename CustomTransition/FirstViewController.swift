//
//  ViewController.swift
//  CustomTransiotion
//
//  Created by Malinka S on 4/18/18.
//  Copyright © 2018 Malinka. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet private weak var openButton: UIButton!
    private let scaleTransition = ScaleAnimator()
    private let popTransition = PopAnimator()
    private let rotateAndScaleTransition = RotateAndScaleAnimator()
    private var animationType: AnimationType!

    override func viewDidLoad() {
        super.viewDidLoad()
        /// Define required action once the transition is completed
        scaleTransition.dismissCompletion = {
            print("dismissing scale")
        }
        popTransition.dismissCompletion = {
            print("dismissing pop")
        }
        rotateAndScaleTransition.dismissCompletion = {
            print("dismissing rotate")
        }
    }

    @IBAction private func didTapOpen(_ sender: UIButton) {
        animationType = .scale
        presentSecondViewController()
    }

    @IBAction private func didTapPop(_ sender: UIButton) {
        animationType = .pop
        presentSecondViewController()
    }

    @IBAction private func didTapRotate(_ sender: UIButton) {
        animationType = .rotate
        presentSecondViewController()
    }

    private func presentSecondViewController() {
        let second = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "SecondViewController")
        second.transitioningDelegate = self
        present(second, animated: true, completion: nil)
    }

}

extension FirstViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let animationType = animationType {
            switch animationType {
            case .pop:
                popTransition.presenting = true
                popTransition.originFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0)
                return popTransition
            case .rotate:
                rotateAndScaleTransition.presenting = true
                rotateAndScaleTransition.originFrame = CGRect(x: UIScreen.main.bounds.width/2,
                                                              y: UIScreen.main.bounds.height/2,
                                                              width: 1,
                                                              height: 1)
                return rotateAndScaleTransition
            case .scale:
                scaleTransition.presenting = true
                scaleTransition.originFrame = openButton.frame
                return scaleTransition
            }
        }
        return nil
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let animationType = animationType {
            switch animationType {
            case .pop:
                popTransition.presenting = false
                return popTransition
            case .rotate:
                rotateAndScaleTransition.presenting = false
                return rotateAndScaleTransition
            default:
                scaleTransition.presenting = false
                return scaleTransition
            }
        }
        return nil
    }

}

