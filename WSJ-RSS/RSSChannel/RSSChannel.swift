//
//  RSSChannel.swift
//  WSJ-RSS
//
//  Created by Practice on 10/19/19.
//  Copyright © 2019 PH Assignment. All rights reserved.
//

import Foundation

struct RSSChannel {
    var title: String
    var url: URL
    
    init(title: String, url: URL) {
        self.title = title
        self.url = url
    }
}
