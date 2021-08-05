//
//  Navigator.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/5/21.
//

import Foundation
import UIKit

protocol Navigatable {
    var navigator: Navigator? { get set }
}

class Navigator {
    static var `default` = Navigator()

    // MARK: - segues list, all app scenes
    enum Scene {
        case tab(viewModel: ViewModel)
        case typeSelect(viewModel: ViewModel)
    }

    enum Transition {
        case root(in: UIWindow)
        case navigation(type: Int)
        case modal
        case detail
    }

    // MARK: - get a single VC
    func get(segue: Scene) -> UIViewController? {
        switch segue {
        case .tab(let viewModel):
            return NavigationController(rootViewController: TabBarViewController(viewModel: viewModel, navigator: self))
        case .typeSelect(viewModel: let viewModel):
            let typeVC = StoryboardName.typeSelect.viewController as? TypeSelectViewController
            typeVC?.setup(viewModel: viewModel, navigator: self)
            return typeVC ?? UIViewController()
        }
    }

    func pop(sender: UIViewController?, toRoot: Bool = false) {
        if toRoot {
            sender?.navigationController?.popToRootViewController(animated: true)
        } else {
            sender?.navigationController?.popViewController(animated: true)
        }
    }

    func dismiss(sender: UIViewController?) {
        sender?.navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - invoke a single segue
    func show(segue: Scene, sender: UIViewController?, transition: Transition = .navigation(type: 0)) {
        if let target = get(segue: segue) {
            show(target: target, sender: sender, transition: transition)
        }
    }

    private func show(target: UIViewController, sender: UIViewController?, transition: Transition) {
        switch transition {
        case .root(in: let window):
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                window.rootViewController = target
            }, completion: nil)
            return
        default: break
        }

        guard let sender = sender else {
            fatalError("You need to pass in a sender for .navigation or .modal transitions")
        }

        switch transition {
        case .navigation:
            if let nav = sender.navigationController {
                // push controller to navigation stack
                nav.pushViewController(target, animated: true)
            }
        default: break
        }
    }
}
