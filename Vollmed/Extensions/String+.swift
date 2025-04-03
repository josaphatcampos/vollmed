//
//  String+.swift
//  Vollmed
//
//  Created by Josaphat Campos Pereira on 02/04/25.
//

import Foundation

extension String {
    func convertDateStringToReadableDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: self) else {
            return ""
        }
        dateFormatter.dateFormat = "dd MMMM yyyy 'às' HH:mm"
        return dateFormatter.string(from: date)
    }
}
