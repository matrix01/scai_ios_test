//
//  ViewController.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/5/21.
//

import UIKit

class ViewController: UIViewController, Navigatable {
    var viewModel: ViewModel?
    var navigator: Navigator?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func setup(viewModel: ViewModel?, navigator: Navigator) {
        self.viewModel = viewModel
        self.navigator = navigator
    }
}
