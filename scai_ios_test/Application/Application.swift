//
//  Application.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/5/21.
//

import Foundation
import UIKit

final class Application: NSObject {
    static let shared = Application()
    var window: UIWindow?
    var provider: NetworkManager?
    let navigator: Navigator

    override private init() {
        navigator = Navigator.default
        super.init()
        updateProvider()
        setupTabAppearance()
    }

    private func updateProvider() {
        provider = NetworkManager()
    }

    func presentInitialScreen(in window: UIWindow?) {
        guard let window = window, let provider = provider else {
            print("Could not init screen")
            return
        }
        self.window = window
        let viewModel = TabBarViewModel(provider: provider)
        self.navigator.show(segue: .tab(viewModel: viewModel),
                            sender: nil,
                            transition: .root(in: window))
    }
    
    private func setupTabAppearance() {
        UITabBar.appearance().tintColor = .orange
    }
}
