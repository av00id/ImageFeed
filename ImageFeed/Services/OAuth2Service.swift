//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 20.12.2022.
//

import Foundation

final class OAuth2Service {
    
    private var task: URLSessionTask?
    private var lastCode: String?
    private let networkClient = NetworkRouting()
    
    func fetchAuthToken(_ code: String, handler: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code, let request = makeRequest(code: code) else { return }
        
        task?.cancel()
        lastCode = code
        
        
        task = networkClient.fetch(requestType: .urlRequest(urlRequest: request)) {
            [weak self] (response: Result<OAuthTokenResponseBody, Error>) in            
            
            guard let self = self else { return }
            self.task = nil
            
            switch response {
            case .success(let data):
                handler(.success(data.accessToken))
            case .failure(let error):
                self.lastCode = nil
                handler(.failure(error))
            }
        }
    }
    private func makeRequest(code: String) -> URLRequest? {
        if var urlComponents = URLComponents(string: Constants.tokenURL) {
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: Constants.accessKey),
                URLQueryItem(name: "client_secret", value: Constants.secretKey),
                URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "grant_type", value: "authorization_code")]
            
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "POST"
            
            return request
        }
        return nil
    }
}
