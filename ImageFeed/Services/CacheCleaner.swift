//
//  CacheCleaner.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 10.02.2023.
//

import Foundation
import Kingfisher

class CacheCleaner {
    static func clean() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
    }
}
