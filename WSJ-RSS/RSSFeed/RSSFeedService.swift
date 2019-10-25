//
//  RSSFeedService.swift
//  WSJ-RSS
//
//  Created by Practice on 10/20/19.
//  Copyright © 2019 PH Assignment. All rights reserved.
//

import Foundation

class RSSFeedService {
    
    func getFeeds(with channel: RSSChannel) -> Result<RSSFeedChannel, XMLFeedParseError> {
        let parser = XMLFeedParser(with: channel.url)
        return parser.parse()
    }
}
