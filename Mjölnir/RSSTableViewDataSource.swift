//
//  RSSTableViewDataSource.swift
//  Mjölnir
//
//  Created by Stefán Geir Sigfússon on 16.2.2015.
//  Copyright (c) 2015 Stefán Geir. All rights reserved.
//

import UIKit

class RSSTableViewDataSource: NSObject, UITableViewDataSource, MWFeedParserDelegate
{
	var items = [MWFeedItem]()
    weak var controller: RSSTableViewController?
	
	func getItemLinkInRow(row: Int) -> String {
		return items[row].link
	}
	func getItemTitleInRow(row: Int) -> String {
		return items[row].title
	}
	
	
	// MARK: - Table view data source
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier(reusableNewsCellIdentifier, forIndexPath: indexPath) as RSSTableViewCell
        if indexPath.row < items.count {
            cell.item = items[indexPath.row]
        }
		return cell
	}
    
    // MARK: - FeedParserDelegate
    
    var feedParser: MWFeedParser?
    
    func request() {
        items = [MWFeedItem]()
        let URL = NSURL(string: "http://www.mjolnir.is/feed")
        feedParser = MWFeedParser(feedURL: URL);
        feedParser!.delegate = self
        feedParser!.feedParseType = ParseTypeFull
        feedParser!.connectionType = ConnectionTypeAsynchronously
        feedParser!.parse()
    }
    
    
    
    func feedParser(parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
        //println(info)
        // title = info.title
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        //println(item)
        items.append(item)
    }
    
    func feedParserDidStart(parser: MWFeedParser) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func feedParserDidFinish(parser: MWFeedParser) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if let controller = controller {
            controller.refreshControl?.endRefreshing()
            controller.tableView.reloadData()
        }
    }
	
	
	
}
