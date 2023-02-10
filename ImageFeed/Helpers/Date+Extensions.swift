//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 10.02.2023.
//

import Foundation

extension Date {
    
    var dateTimeString: String {
        String(DateFormatter.displayFormat.string(from: self))
    }
    
    func convertToDate(_ dateString: String) -> Date? {
        let date = DateFormatter.isoDateFormatter.date(from: dateString)
        return date
    }
}
