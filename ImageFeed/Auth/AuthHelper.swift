//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 15.02.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}

class AuthHelper: AuthHelperProtocol{
    /*let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration) {
        self.configuration = configuration
    } */
    
    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
    }
    
    func authURL() -> URL {
        var urlComponents = URLComponents(string: AuthConfiguration.unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AuthConfiguration.accessKey),
            URLQueryItem(name: "redirect_uri", value: AuthConfiguration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AuthConfiguration.accessScope)
        ]
        return urlComponents.url!
    }
    
    func code(from url: URL) -> String? {
        guard
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == AuthConfiguration.nativePath,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code"})
        else {
            return nil
        }
        return codeItem.value
    }
}
