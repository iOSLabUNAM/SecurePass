//
//  SecureKeys.swift
//  SecurePass
//
//  Created by Luis Ezcurdia on 19/01/24.
//

import Foundation

struct SecureKeys {
    private let usernameKey = "com.3zcurdia.SecureKeys.usernameKey"
    private let accessTokenKey = "com.3zcurdia.SecureKeys.accessTokenKey"
    private let service = KeychainService()

    var username: String? {
        get {
            return try? service.load(key: usernameKey)
        }
        set {
            guard let value = newValue else { return }
            try? service.save(key: usernameKey, value: value)
        }
    }

    var accessToken: String? {
        get {
            return try? service.load(key: accessTokenKey)
        }
        set {
            guard let value = newValue else { return }
            try? service.save(key: accessTokenKey, value: value)
        }
    }
}
