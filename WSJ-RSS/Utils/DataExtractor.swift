//
//  DataExtractor.swift
//  WSJ-RSS
//
//  Created by Practice on 10/19/19.
//  Copyright © 2019 PH Assignment. All rights reserved.
//

import Foundation

enum LocalDataType: Equatable {
    case Channel
}

class DataExtractor {
    // get data from local plist and return as dictionary
    static func getDataDict(for type: LocalDataType) -> [String: Any]? {
        var plistName: String? = nil
        switch type {
        case .Channel:
            plistName = "channels"
        }
        if let plistName = plistName, let path = Bundle.main.path(forResource: plistName, ofType: "plist") {
            if let xml = FileManager.default.contents(atPath: path) {
                do {
                    if let dict = (try PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? Dictionary<String, Any> {
                        return dict
                    } else {
                        print("Error: Failed to cast property list as dictionary")
                    }
                } catch {
                    print("Error: Unable to parse property list")
                    return nil
                }
            }
        }
        print("Error: Unable to get data from local")
        return nil
    }
}
