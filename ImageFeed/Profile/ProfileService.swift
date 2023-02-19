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
    
    func fetchProfile(completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        
        guard let url = URL(string: AuthConfiguration.profileURL) else {
            fatalError("Unable to build profile URL")
        }
            task = networkClient.fetch(requestType: .url(url: url)) {
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
    
  
             
    

