//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 20.12.2022.
//

import Foundation

final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case bearerToken
    }
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            return userDefaults.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.bearerToken.rawValue)
        }
    }
}

