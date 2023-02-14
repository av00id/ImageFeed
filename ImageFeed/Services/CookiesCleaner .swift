//
//  CookiesCleaner .swift
//  ImageFeed
//
//  Created by Сергей Андреев on 07.02.2023.
//
import Foundation
import WebKit

class CookiesCleaner {
   static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
