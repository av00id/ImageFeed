//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 20.12.2022.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case bearerToken
    }
    private let keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            return keychainWrapper.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            if let token = newValue {
                keychainWrapper.set(token, forKey: Keys.bearerToken.rawValue)
            }
        }
    }
}
