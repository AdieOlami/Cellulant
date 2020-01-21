//
//  User.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation

struct User: Codable {
    var email: String?
    var password: String?
    var isValid: Bool? = false
}


extension User {
    
    func save() {
        let keychain = KeyChainStorage.instance
        keychain.saveCurrentUser(self)
    }

    static func currentUser() -> User? {
        let keychain = KeyChainStorage.instance
        if let user = keychain.getCurrentUser() {
            return user
        }
        return nil
    }

    static func removeCurrentUser() {
        let keychain = KeyChainStorage.instance
        keychain.clearAll()
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.password == rhs.password
    }
}
