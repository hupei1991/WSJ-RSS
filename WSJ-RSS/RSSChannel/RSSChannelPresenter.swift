//
//  RSSChannelPresenter.swift
//  WSJ-RSS
//
//  Created by Practice on 10/20/19.
//  Copyright © 2019 PH Assignment. All rights reserved.
//

import Foundation

protocol ChannelView: class {
    func startLoading()
    func finishLoading()
    func setChannels(with channels: [RSSChannel])
}

class RSSChannelPresenter {
    
    weak private var channelView: ChannelView?
    private let channelService = RSSChannelService()
    
    func attachView(with view: ChannelView) {
        self.channelView = view
    }
    
    func detachView() {
        self.channelView = nil
    }
    
    func getChannels() {
        self.channelView?.startLoading()
        self.channelService.getChannels {
            [weak self] channels in
            self?.channelView?.finishLoading()
            self?.channelView?.setChannels(with: channels.sorted {
                lhs, rhs in
                lhs.title < rhs.title
            })
        }
    }
    
}
