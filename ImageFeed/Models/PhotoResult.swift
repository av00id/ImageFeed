//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 26.01.2023.
//

import Foundation

struct PhotoResult: Decodable {
    
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let description: String?
    let isLiked: Bool
    let urls: UrlsResult
    
    struct UrlsResult: Decodable {
        let full: URL
        let small: URL
        let thumb: URL
    }
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, description, urls
        case createdAt = "created_at"
        case isLiked = "liked_by_user"
    }
}
struct LikePhotoResult: Decodable {
    let photo: PhotoResult
}


