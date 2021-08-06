//
//  UIView+Utils.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/7/21.
//

import UIKit

extension UIView {
    var height: CGFloat {
        bounds.height
    }

    var width: CGFloat {
        bounds.width
    }

    var x: CGFloat {
        frame.origin.x
    }

    var y: CGFloat {
        frame.origin.y
    }
}
