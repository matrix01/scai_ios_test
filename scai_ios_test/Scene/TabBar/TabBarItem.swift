//
//  TabBarItem.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/6/21.
//

import UIKit

enum TabBarItem: Int {
    case camera, gallery
    
    private func controller(with viewModel: ViewModel, navigator: Navigator) -> UIViewController {
        switch self {
        case .camera:
            let viewController = StoryboardName.landing.viewController as? LandingViewController
            viewController?.setup(viewModel: viewModel, navigator: navigator)
            return viewController ?? UIViewController()
        case .gallery:
            let viewController = StoryboardName.gallery.viewController as? GalleryViewController
            viewController?.setup(viewModel: viewModel, navigator: navigator)
            return viewController ?? UIViewController()
        }
    }
    
    var image: UIImage? {
        switch self {
        case .camera: return UIImage(systemName: "camera")
        case .gallery: return UIImage(systemName: "list.and.film")
        }
    }

    var title: String {
        switch self {
        case .camera: return "Camera"
        case .gallery: return "Gallery"
        }
    }

    var tintColor: UIColor? {
        return UIColor.orange
    }

    func getController(with viewModel: ViewModel, navigator: Navigator) -> UIViewController {
        let vc = controller(with: viewModel, navigator: navigator)
        let item = UITabBarItem(title: title, image: image, tag: rawValue)
        vc.tabBarItem = item
        return vc
    }
}
