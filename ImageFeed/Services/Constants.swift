//
//  Constants.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 16.12.2022.
//

import Foundation

enum Constants {
    static let accessKey = "l0L6tVRdWYX9BJT5cAFWNdAayMtjOkOezSv_CtvJ3_4"
    static let secretKey = "zelyPd6t4QXwb6krdIIu_mvCozxQ7172j21MeaE6Bgk"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

