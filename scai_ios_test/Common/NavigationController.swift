//
//  NavigationController.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/5/21.
//

import UIKit

class NavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        interactivePopGestureRecognizer?.delegate = nil // Enable default iOS back swipe gesture
    }
}
