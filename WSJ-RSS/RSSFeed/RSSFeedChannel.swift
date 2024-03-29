//
//  RSSFeedChannel.swift
//  WSJ-RSS
//
//  Created by Practice on 10/23/19.
//  Copyright © 2019 PH Assignment. All rights reserved.
//

import Foundation

struct RSSFeedChannel {
    var title: String?
    var link: String?
    var description: String?
    var pubdate: String?
    
    var items: [RSSFeed] = []
}
