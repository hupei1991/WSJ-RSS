//
//  RSSFeedPresenter.swift
//  WSJ-RSS
//
//  Created by Practice on 10/20/19.
//  Copyright © 2019 PH Assignment. All rights reserved.
//

import Foundation
protocol FeedView: class {
    func receivedTitle(with title: String)
    func startLoading()
    func finishLoading()
    func receivedFeedChannel(with feedChannel: RSSFeedChannel)
    func parsingFailed(error: XMLFeedParseError)
    
}

class RSSFeedPresenter {
    weak private var feedView: FeedView?
    private var service = RSSFeedService()
    var sourceChannel: RSSChannel?
    
    func attachView(with view: FeedView) {
        self.feedView = view
    }
    
    func detachView() {
        self.feedView = nil
    }
    
    func requestTitle() {
        feedView?.receivedTitle(with: sourceChannel?.title ?? "Feeds")
    }
    
    func getFeeds() {
        feedView?.startLoading()
        DispatchQueue.global().async {
            if let channel = self.sourceChannel {
                switch self.service.getFeeds(with: channel){
                    case .success(var channel):
                        self.feedView?.finishLoading()
                        channel.items.sort {
                            lhs, rhs in
                            DateParser.getDate(from: lhs.pubdate ?? "") ?? Date() > DateParser.getDate(from: rhs.pubdate ?? "") ?? Date()
                        }
                        self.feedView?.receivedFeedChannel(with: channel)
                    case .failure(let error):
                        self.feedView?.finishLoading()
                        self.feedView?.parsingFailed(error: error)
                }
            } else {
                self.feedView?.finishLoading()
                print("Error: Presenter does not contain a source channel")
            }
        }
    }
}
