//
//  AppDelegate.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var shared: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let libsManager = LibsManager.shared
        libsManager.setupLibs(with: window)

        if Config.Network.useStaging == true {
            // Logout
            User.removeCurrentUser()
            AuthManager.removeToken()

        }
        // Show initial screen
//        Application.shared.presentInitialScreen(in: window!)

        return true
    }
}
