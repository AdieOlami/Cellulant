//
//  KeyChainStorage.swift
//  Cellulant
//
//  Created by Olar's Mac on 1/21/20.
//  Copyright © 2020 Adie Olalekan. All rights reserved.
//

import Foundation
import KeychainSwift

class KeyChainStorage {
    private let userKey = "uiush"
    private let tokenKey = "87yJU7h&5644##^7()_&"
    
    static var instance = KeyChainStorage()
    let keychain = KeychainSwift()
    
    private init() {
    }
    
    public func clearAll() {
        keychain.clear()
    }
    
    public func getCurrentUser() -> User? {
        return get(forKey: userKey)
    }
    
    public func saveCurrentUser(_ user: User) {
        put(user, forKey: userKey)
    }
    
    private func put<T>(_ value: T?, forKey key: String) where T: Codable {
        guard let value = value else {
            keychain.delete(key)
            return
        }
        let encoder = JSONEncoder()
        do {
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let encoded = try encoder.encode(value)
            log("THIS ACCESS TOKEN TK \(encoded)", .fuck)
            keychain.set(encoded, forKey: key)
        } catch let error {
            log("(BOUNCEE CC) fatal encoded \(error)) boom", .error)
        }
        
    }
    
    private func get<T>(forKey key: String) -> T? where T: Codable {
        guard let data = keychain.getData(key) else { return nil}
        let decoder = JSONDecoder()
        do {
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch let error {
            log("(BOUNCEE CC) fatal encoded \(error)) boom", .error)
            return T.self as? T
        }
        
    }
}
