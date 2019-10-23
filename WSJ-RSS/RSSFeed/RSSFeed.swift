//
//  RSSFeed.swift
//  WSJ-RSS
//
//  Created by Practice on 10/20/19.
//  Copyright © 2019 PH Assignment. All rights reserved.
//

import Foundation

/* Sample:
    <title>Brazilian Authorities Signal Intent to Focus on Vale Executives in Probe of Dam Collapse</title>
    <link>https://www.wsj.com/articles/brazilian-authorities-signal-intent-to-focus-on-vale-executives-in-probe-of-dam-collapse-11571439581</link>
    <description><![CDATA[Brazilian police believe top executives and managers at Vale deliberately shielded themselves from incriminating information about the state of the company’s dam that collapsed in January to avoid liability, according to a copy of a police inquiry reviewed by The Wall Street Journal.]]></description>
    <content:encoded/>
    <pubDate>Fri, 18 Oct 2019 19:05:00 -0400</pubDate>
    <guid isPermaLink="false">SB11608465883103473909404585619102161691746</guid>
    <category domain="AccessClassName">PAID</category>
    <wsj:articletype>Latin America News</wsj:articletype>
 */
struct RSSFeed {
    var title: String?
    var link: String?
    var description: String?
    var guid: String?
    var pubdate: String?
    var articletype: String?
}
