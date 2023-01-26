//
//  Profile.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 09.01.2023.
//

import Foundation

struct Profile: Decodable {
    let username: String
    let name: String
    let bio: String
    var login: String {"@\(username)"}
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case name = "name"
        case bio = "bio"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        
        bio = try container.decodeIfPresent(String.self, forKey: .bio) ?? ""
        username = try container.decode(String.self, forKey: .username)
    }
}
