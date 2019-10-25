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
                let parser = XMLFeedParser(with: channel.url)
                switch parser.parse() {
                case .success(let channel):
                    self.feedView?.finishLoading()
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
