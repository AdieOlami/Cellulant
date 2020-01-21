//
//  AuthManager.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation
import KeychainAccess
import RxSwift
import RxCocoa

let loggedIn = BehaviorRelay<Bool>(value: false)

class AuthManager {

    /// The default singleton instance.
    static let shared = AuthManager()

    // MARK: - Properties
    fileprivate let tokenKey = "TokenKey"
    fileprivate let keychain = KeyChainStorage.instance

    let tokenChanged = PublishSubject<User?>()

    init() {
        loggedIn.accept(hasValidToken)
    }

    var token: User? {
        get {
            guard let auth = keychain.getCurrentUser() else { return nil }
            return auth
        }
        set {
            if let token = newValue {
                keychain.saveCurrentUser(token)
            }
            tokenChanged.onNext(newValue)
            loggedIn.accept(hasValidToken)
        }
    }

    var hasValidToken: Bool {
        return token?.isValid == true
    }

    class func setToken(token: User) {
        AuthManager.shared.token = token
    }

    class func removeToken() {
        AuthManager.shared.token = nil
    }

    class func tokenValidated() {
        AuthManager.shared.token?.isValid = true
    }
}
