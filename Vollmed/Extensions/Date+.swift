//
//  Date+.swift
//  Vollmed
//
//  Created by Josaphat Campos Pereira on 02/04/25.
//

import Foundation

extension Date {
    func convertToString(format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
