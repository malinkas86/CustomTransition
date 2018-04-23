//
//  SecondViewController.swift
//  CustomTransiotion
//
//  Created by Malinka S on 4/18/18.
//  Copyright © 2018 Malinka. All rights reserved.
//

import UIKit

final class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didTapDismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
