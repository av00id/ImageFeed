//
//  DateFormatter+Extension.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 02.02.2023.
//

import Foundation

extension DateFormatter {
    var displayFormat: DateFormatter {
        self.dateStyle = .long
        self.timeStyle = .none
        return self
    }
} 
