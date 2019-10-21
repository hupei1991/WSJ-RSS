//
//  RSSChannelService.swift
//  WSJ-RSS
//
//  Created by Practice on 10/20/19.
//  Copyright © 2019 PH Assignment. All rights reserved.
//

import Foundation

class RSSChannelService {
    
    func getChannels(callback: @escaping ([RSSChannel]) -> Void) {
        var channelList: [RSSChannel] = []
        if let dataDict = DataExtractor.getDataDict(for: .Channel) {
            for (_, channelEntry) in dataDict {
                if let channelEntry = channelEntry as? [String: Any] {
                    var title: String? = nil
                    var url: URL? = nil
                    if let _title = channelEntry["title"] as? String {
                        title = _title
                    }
                    if let _urlString = channelEntry["urlString"] as? String {
                        url = URL(string: _urlString)
                    }
                    if let title = title, let url = url {
                        channelList.append(RSSChannel(title: title, url: url))
                    }
                }

            }
        }
        DispatchQueue.global().async {
            callback(channelList)
        }
    }
}
