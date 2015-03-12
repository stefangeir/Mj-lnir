//
//  RSSTableViewDelegate.swift
//  Mjölnir
//
//  Created by Stefán Geir Sigfússon on 16.2.2015.
//  Copyright (c) 2015 Stefán Geir. All rights reserved.
//

import UIKit

class RSSTableViewDelegate: NSObject, UITableViewDelegate
{
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}

}
