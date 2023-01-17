//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 09.01.2023.
//

import Foundation

final class ProfileService {
    
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    static let shared = ProfileService()
    private(set) var profile: Profile?
    
    private let networkClient = NetworkRouting()
    
    func fetchProfile(_ token: String, completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        
        if let request = makeRequest(authToken: token) {
            task = networkClient.fetch(requestType: .urlRequest(urlRequest: request)) {
                [weak self] (result: Result<Profile, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let profile):
                    self.profile = profile
                    completion(.success(profile.username))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func makeRequest(authToken token: String) -> URLRequest? {
        if let urlComponents = URLComponents(string: Constants.profileURL) {
            var request = URLRequest(url: urlComponents.url!)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            return request
        }
        return nil
    }
}
