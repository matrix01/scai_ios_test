//
//  AppDelegate.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/5/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        Application.shared.presentInitialScreen(in: window)
        window?.makeKeyAndVisible()
        
        return true
    }
}

