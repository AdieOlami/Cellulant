//
//  Application.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import UIKit

final class Application: NSObject {
    static let shared = Application()

    var window: UIWindow?

    var provider: Api?
    let authManager: AuthManager
    let navigator: Navigator

    private override init() {
        authManager = AuthManager.shared
        navigator = Navigator.default
        super.init()
        updateProvider()
    }

    private func updateProvider() {
        let staging = Config.Network.useStaging
        let fastProvider = staging ? FastNetworking.stubbingFastNetworking(): FastNetworking.fastNetworking()
        let restApi = RestApi(fastProvider: fastProvider)
        provider = restApi

    }

    func presentInitialScreen(in window: UIWindow?) {
        updateProvider()

        guard let window = window, let provider = provider else {
            print("NOTHING SHOWS")
            return
        }
        self.window = window
        
//        presentTestScreen(in: window)
//        return

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            let keychain = KeyChainStorage.instance
            //REMOVE THIS LINE TO JUST VIEW DATA IF LOGGED IN
            keychain.clearAll()
            if keychain.getCurrentUser() != nil {
                let viewModel = UserListViewModel(provider: provider)
                self.navigator.show(segue: .userList(viewModel: viewModel), sender: nil, transition: .root(in: window))
            } else {
                let viewModel = AuthViewModel(provider: provider)
                self.navigator.show(segue: .login(viewModel: viewModel), sender: nil, transition: .root(in: window))
            }
        }
    }
    
    func presentTestScreen(in window: UIWindow?) {
    }
}
