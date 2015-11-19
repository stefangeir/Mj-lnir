//
//  RSSDataModel.swift
//  Mjölnir
//
//  Created by Stefán Geir on 19.3.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import MWFeedParser
import UIKit


struct RSSNetworking {
    static let FetchedNews = "Fetched News"
    static let ErrorFetchingNews = "Error Fetching News"
}

class RSSDataModel: NSObject, MWFeedParserDelegate
{
    var data = [MWFeedItem]()
    
    // MARK: - FeedParserDelegate
    
    var feedParser: MWFeedParser?
    
    func request() {
        data = [MWFeedItem]()
        let URL = NSURL(string: "http://www.mjolnir.is/feed")
        feedParser = MWFeedParser(feedURL: URL);
        feedParser!.delegate = self
        feedParser!.feedParseType = ParseTypeFull
        feedParser!.connectionType = ConnectionTypeAsynchronously
        feedParser!.parse()
    }
    
    
    
    func feedParser(parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        data.append(item)
    }
    
    func feedParserDidStart(parser: MWFeedParser) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func feedParserDidFinish(parser: MWFeedParser) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        NSNotificationCenter.defaultCenter().postNotificationName(RSSNetworking.FetchedNews, object: self)
    }
    
    func feedParser(parser: MWFeedParser!, didFailWithError error: NSError!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        NSNotificationCenter.defaultCenter().postNotificationName(RSSNetworking.ErrorFetchingNews, object: self, userInfo: ["Error" : error])
    }
}
