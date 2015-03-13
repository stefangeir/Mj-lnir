//
//  RSSTableViewController.swift
//  Mjölnir
//
//  Created by Stefán Geir Sigfússon on 15.2.2015.
//  Copyright (c) 2015 Stefán Geir. All rights reserved.
//

import UIKit

let reusableNewsCellIdentifier = "reusable.NewsCell"
class RSSTableViewController: UITableViewController, MWFeedParserDelegate {

	let datasource = RSSTableViewDataSource()
	let delegate = RSSTableViewDelegate()
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
        datasource.controller = self
		tableView.dataSource = datasource
        tableView.delegate = delegate
        

        title = "Fréttir"
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.tableFooterView?.hidden = true
        
        refresh()
	}
    
    func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        datasource.request()
    }

    // MARK: - Navigation
    let viewNewsItemSegueString = "segue.viewNewsItem"

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == viewNewsItemSegueString {
			if let cell = sender as? UITableViewCell {
				if let web = segue.destinationViewController as? RSSWebViewController {
					let row = tableView.indexPathForCell(cell)?.row
					web.urlString = datasource.getItemLinkInRow(row!)
					web.title = datasource.getItemTitleInRow(row!)
				}
			}
		}
	}
	
	


}
