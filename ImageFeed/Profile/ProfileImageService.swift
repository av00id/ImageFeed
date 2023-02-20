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
                              _ completion: @escaping (Result<Void, Error>) -> Void) {
        task?.cancel()
        
        guard let url = URL(string: "\(AuthConfiguration.profileImageURL)/\(username)") else {
            fatalError("Enable to build profile URL")
        }
        task = networkClient.fetch(requestType: .url(url: url)) {
            [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let userProfile):
                if let image = userProfile.profileImage?.image {
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
            }
        }
    }
}



