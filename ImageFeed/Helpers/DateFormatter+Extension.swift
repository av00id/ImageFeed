//
//  DateFormatter+Extension.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 02.02.2023.
//

import Foundation

extension DateFormatter {
    
    static let displayFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_ru")
        return formatter
    }()
    
    static let isoDateFormatter = ISO8601DateFormatter()
} 
