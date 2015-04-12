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
    
            return 110
        }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        if indexPath.row == controller.datasource.fbPosts.count {
//            return 40
//        } else {
//            var height: CGFloat = 0
//
//            var maxWidth = CGFloat()
//            if let textBoxWidth = controller.datasource.textBoxWidth {
//                maxWidth = textBoxWidth
//                println("Using actual tetboxwidht")
//            } else {
//                var maxWidth = UIScreen.mainScreen().bounds.size.width - 60 - 10 - 10 - 40
//            }
//            
//            let row = indexPath.row
//            
//            println("row nr \(row)")
//            if row < controller.datasource.fbPosts.count {
//                let myOptions: NSStringDrawingOptions = unsafeBitCast(NSStringDrawingOptions.UsesLineFragmentOrigin.rawValue,
//                    NSStringDrawingOptions.self)
//                
//                if let postTitle = controller.datasource.fbPosts[row].Title {
//                    let titleAttributes = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
//                    
//                    let titleMeasurementString = NSAttributedString(string: postTitle, attributes:  titleAttributes)
//                    
//                    let titleBounds = titleMeasurementString.boundingRectWithSize(CGSize(width: maxWidth, height: 9999), options: myOptions, context: nil)
//                    height += titleBounds.height
//                    println("added titleheight of \(titleBounds.height)")
//                }
//                
//                if let postMessage = controller.datasource.fbPosts[row].Message {
//                    let  messageAttributes = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
//
//                    let messageMeasurementString = NSAttributedString(string: postMessage, attributes: messageAttributes)
//                    
//                    let messageBounds = messageMeasurementString.boundingRectWithSize(CGSize(width: maxWidth, height: 9999), options: myOptions, context: nil)
//                    height += messageBounds.height
//                    println("added messageheight of  \(messageBounds.height)")
//                }
//            }
//            height += UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote).pointSize
//            
//            return height
//        }
//    }
}

