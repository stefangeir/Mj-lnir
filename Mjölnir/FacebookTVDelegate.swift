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
    
    weak var controller: FacebookTVC!
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        controller.selectedRow(indexPath)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if controller.userIsLoggedIn && indexPath.row == controller.datasource.fbPosts.count {
            controller.datasource.datamodel.performRequest()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // Ef þetta er loading cell er hún 40
            if indexPath.row == controller.datasource.fbPosts.count {
                return 40.0
            }
        
        return 120
    }
}

