//
//  facebookTVDelegate.swift
//  Mjölnir
//
//  Created by Stefán Geir on 21.2.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit

class FacebookTVDelegate: NSObject, UITableViewDelegate
{
    
    weak var controller: FacebookTVC?
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        NSNotificationCenter.defaultCenter().postNotificationName("selectedItemInFacebookView", object:indexPath as NSIndexPath)
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let controller = controller {
            if controller.datasource.paginationNext != nil && indexPath.row == controller.datasource.fbPosts.count {
                controller.datasource.getData()
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if let controller = controller {
            if controller.datasource.paginationNext != nil && indexPath.row == controller.datasource.fbPosts.count {
                return 40.0
            }
        }
        
        return 120
    }
}

