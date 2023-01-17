//
//  ProfileImage.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 09.01.2023.
//

import Foundation

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
    
    var image: String? { large ?? medium ?? small}
}
