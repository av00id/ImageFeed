//
//  UserImage.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 09.01.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
