//
//  DateDisplayParser.swift
//  WSJ-RSS
//
//  Created by Practice on 10/22/19.
//  Copyright © 2019 PH Assignment. All rights reserved.
//

import Foundation

class DateParser {
    static func getDisplay(from rawString: String) -> String? {
        if let date = DateParser.getDate(from: rawString) {
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
        return nil
    }
    
    static func getDate(from rawString: String) -> Date? {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        return inputDateFormatter.date(from: rawString)
    }
}
