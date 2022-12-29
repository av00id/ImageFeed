//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 20.12.2022.
//

import Foundation

final class OAuth2Service {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        if var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") {
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: Constants.accessKey),
                URLQueryItem(name: "client_secret", value: Constants.secretKey),
                URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "grant_type", value: "authorization_code")]
            
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "POST"
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard self != nil else { return }
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode >= 300 {
                    completion(.failure(NetworkError.codeError))
                    return
                }
                
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(decodedData.accessToken))
                        }
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
}
