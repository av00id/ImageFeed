//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 09.01.2023.
//

import Foundation

final class ProfileImageService {
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let networkClient = NetworkRouting()
    
    func fetchProfileImageURL(username: String,
                              token: String?,
                              _ completion: @escaping (Result<Void, Error>) -> Void) {
        task?.cancel()
        
        if let request = makeRequest(username: username, token: token) {
            task = networkClient.fetch(requestType: .urlRequest(urlRequest: request)) {
                [weak self] (result: Result<UserResult, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let userProfile):
                    print(userProfile)
                    if let image = userProfile.profileImage?.image {
                        print(image)
                        self.avatarURL = image
                        NotificationCenter.default
                            .post(
                                name: ProfileImageService.didChangeNotification,
                                object: self,
                                userInfo: ["URL": image]
                            )
                    }
                    completion(.success(()))
                    
                case .failure(let error):
                    completion(.failure(error))
                    print(error)
                }
            }
        }
    }
    
    private func makeRequest(username: String, token: String?) -> URLRequest? {
        if let urlComponents = URLComponents(string: "\(Constants.profileImageURL)/\(username)") {
            var request = URLRequest(url: urlComponents.url!)
            if let token = token {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            return request
        }
        return nil
    }
}
