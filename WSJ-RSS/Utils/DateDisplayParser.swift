//
//  DateDisplayParser.swift
//  WSJ-RSS
//
//  Created by Practice on 10/22/19.
//  Copyright © 2019 PH Assignment. All rights reserved.
//

import Foundation

class DateDisplayParser {
    static func getDisplay(from rawString: String) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        if let date = inputDateFormatter.date(from: rawString) {
            let dateFormatter = DateFormatter()
            if Calendar.current.isDateInToday(date) {
                dateFormatter.dateStyle = .none
                dateFormatter.timeStyle = .short
            } else {
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
            }
            dateFormatter.locale = Locale(identifier: "en_US")
            return dateFormatter.string(from: date)
        }
        print("Error: Failed to parse date string: \(rawString)")
        return "Unknown"
    }
}
