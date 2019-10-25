//
//  XMLFeedParser.swift
//  WSJ-RSS
//
//  Created by Practice on 10/20/19.
//  Copyright © 2019 PH Assignment. All rights reserved.
//

import Foundation

enum XMLFeedParseError {
    case noContent(reason: String)
    case failedToParse(reason: String)
    case commonError(reason: String)
}

extension XMLFeedParseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noContent(let reason):
            return "Failed to get content from URL: \(reason)"
        case .commonError(let reason):
            return "Unable to parse feed: \(reason)"
        case .failedToParse(let reason):
            return "XMLParser failed to parse: \(reason)"
        }
    }
}


class XMLFeedParser: NSObject {
    private var url: URL
    private var feedChannel: RSSFeedChannel? = nil
    private var currentFeed: RSSFeed? = nil
    private var currentPath = URL(string: "/")!
    private var errorOccurred: Error? = nil
    
    init(with url: URL) {
        self.url = url
    }
    
    func parse() -> Result<RSSFeedChannel, XMLFeedParseError> {
        do {
            let data = try Data(contentsOf: self.url)
            let parser = XMLParser(data: data)

            parser.delegate = self
            if !parser.parse() {
                return .failure(.failedToParse(reason: "Failed to parse by XMLParser"))
            }
            if self.errorOccurred == nil {
                if let feedChannel = self.feedChannel {
                    return .success(feedChannel)
                } else {
                    return .failure(.failedToParse(reason: "Failed to initialize channel"))
                }
            } else {
                return .failure(.failedToParse(reason: self.errorOccurred!.localizedDescription))
            }
        } catch {
            return .failure(.noContent(reason: error.localizedDescription))
        }
    }
}

extension XMLFeedParser: XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) {
        print("XMLFeedParser starts parsing document")
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("XMLFeedParser ends parsing document")
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.currentPath = self.currentPath.appendingPathComponent(elementName)
        print("start: \(self.currentPath.absoluteString)")
        if let map = RSSFeedMap.match(self.currentPath.absoluteString) {
            if map == .rssChannel {
                self.feedChannel = RSSFeedChannel()
            }
            if map == .rssChannelItem {
                self.currentFeed = RSSFeed()
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("end: \(self.currentPath.absoluteString)")
        if let map = RSSFeedMap.match(self.currentPath.absoluteString) {
            if map == .rssChannelItem {
                if let currentFeed = self.currentFeed {
                    self.feedChannel?.items.append(currentFeed)
                }
            }
        }
        self.currentPath = self.currentPath.deletingLastPathComponent()
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let santinizedValue = string.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        if self.feedChannel != nil {
            RSSFeedMap.mapRSSFeedChannel(for: &self.feedChannel!, at: self.currentPath.absoluteString, using: santinizedValue)
        }
        if self.currentFeed != nil {
            RSSFeedMap.mapRSSFeed(for: &currentFeed!, at: self.currentPath.absoluteString, using: santinizedValue)
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.errorOccurred = parseError
    }
}

