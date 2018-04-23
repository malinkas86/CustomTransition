//
//  Animator.swift
//  CustomTransition
//
//  Created by Malinka S on 4/23/18.
//  Copyright © 2018 Malinka. All rights reserved.
//

import UIKit

protocol Animator {
    var duration: TimeInterval { get }
    var presenting: Bool { get }
    var originFrame: CGRect { get }
    var dismissCompletion: (()->Void)? { get }
}
