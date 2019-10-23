//
//  RSSFeedMap.swift
//  WSJ-RSS
//
//  Created by Practice on 10/21/19.
//  Copyright © 2019 PH Assignment. All rights reserved.
//

import Foundation

enum RSSFeedMap: String, CaseIterable {
//    case rss                        = "/rss"
//    case rssChannel                 = "/rss/channel"
//    case rssChannelTitle            = "/rss/channel/title"
//    case rssChannelLink             = "/rss/channel/link"
//    case rssChannelDescription      = "/rss/channel/description"
    
    case rssChannelItem             = "/rss/channel/item"
    case rssChannelItemTitle        = "/rss/channel/item/title"
    case rssChannelItemLink         = "/rss/channel/item/link"
    case rssChannelItemDescription  = "/rss/channel/item/description"
    case rssChannelItemGUID         = "/rss/channel/item/guid"
    case rssChannelItemPubDate      = "/rss/channel/item/pubDate"
    case rssChannelItemArticleType  = "/rss/channel/item/wsj:articletype"
}

extension RSSFeedMap {
    static func match(_ feedPath: String) -> RSSFeedMap? {
        var newPath = feedPath
        if feedPath.count > 1, feedPath[feedPath.index(before: feedPath.endIndex)] == "/" {
            newPath = String(feedPath.dropLast())
        }
        for value in RSSFeedMap.allCases {
            if value.rawValue.uppercased() == newPath.uppercased() {
                return value
            }
        }
        return nil
    }
    
    
    static func map(for feed: inout RSSFeed, at feedPath: String, using value: String) {
        if let feedMap = RSSFeedMap.match(feedPath) {
            switch feedMap {
            case .rssChannelItemGUID:
                feed.guid = (feed.guid ?? "") + value
            case .rssChannelItemArticleType:
                feed.articletype = (feed.articletype ?? "") + value
            case .rssChannelItemLink:
                feed.link = (feed.link ?? "") + value
            case .rssChannelItemPubDate:
                feed.pubdate = (feed.pubdate ?? "") + value
            case .rssChannelItemDescription:
                feed.description = (feed.description ?? "") + value
            case .rssChannelItemTitle:
                feed.title = (feed.title ?? "") + value
            default:
                break
            }
        }
    }
}
