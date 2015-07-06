//
//  RSSTableViewDataSource.swift
//  Mjölnir
//
//  Created by Stefán Geir Sigfússon on 16.2.2015.
//  Copyright (c) 2015 Stefán Geir. All rights reserved.
//

import UIKit

class RSSTableViewDataSource: NSObject, UITableViewDataSource
{
    var datamodel = RSSDataModel()
    
    weak var controller: RSSTableViewController!
	
	func getItemLinkInRow(row: Int) -> String {
		return datamodel.data[row].link
	}
	func getItemTitleInRow(row: Int) -> String {
		return datamodel.data[row].title
	}
    
    func didFetchNews() {
        controller.refreshControl?.endRefreshing()
        controller.tableView.reloadData()
    }
    
    func errorFetchingNews(note: NSNotification) {
        if let errorDict = note.userInfo as? [String : NSError] {
            if let error = errorDict["Error"] {
                let alertController = UIAlertController(title: "Vesen: ", message:
                    error.localizedDescription, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Flott", style: .Default,handler: nil))
                controller.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
	
	// MARK: - Table view data source
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return datamodel.data.count
	}
	
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier(reusableNewsCellIdentifier, forIndexPath: indexPath) as! RSSTableViewCell
        if indexPath.row < datamodel.data.count {
            cell.item = datamodel.data[indexPath.row]
        }
		return cell
	}
    
    
}
