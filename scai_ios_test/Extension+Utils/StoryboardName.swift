//
//  StoryboardName.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/5/21.
//

import UIKit

enum StoryboardName: String {
    case landing = "Landing"
    case gallery = "Gallery"
    case typeSelect = "TypeSelect"
    
    var viewController: ViewController? {
        UIStoryboard(name: self.rawValue, bundle: nil)
            .instantiateInitialViewController() as? ViewController
    }
}
