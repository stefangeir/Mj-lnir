//
//  facebookPostTVCell.swift
//  Mjölnir
//
//  Created by Stefán Geir on 6.3.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit

class FacebookPostTVCell: UITableViewCell
{
    
    //TODO: this wasn't weak, might be a problem
    @IBOutlet weak var fbPostTitleLabel: UILabel!
    @IBOutlet weak var fbPostLabel: UILabel!
    @IBOutlet weak var fbPostTimeLabel: UILabel!
    @IBOutlet weak var fbPostImageView: UIImageView!
    
    var post: FbPost? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        // reset old info
        fbPostTitleLabel?.text = nil
        fbPostTitleLabel.attributedText = nil
        fbPostLabel?.text = nil
        fbPostLabel?.attributedText = nil
        fbPostTimeLabel?.text = nil
        fbPostImageView?.image = nil
        
        //fbPostImageView.contentMode = UIViewContentMode.ScaleAspectFit
        if let post = self.post {
            
            if post.PictureUrl != nil {
                let url = NSURL(string: post.PictureUrl!)
                fbPostImageView.setImageWithURL(url, placeholderImage: UIImage(named: placeholderImageNameString))
            }
            
            if let postLinkName = post.LinkName {
                var postTitle = postLinkName
                if let postDescription = post.Description {
                    postTitle += " - " + postDescription
                    if let caption = post.Caption {
                        postTitle += " - \(caption)"
                    }
                }
                fbPostTitleLabel.text = postTitle
            } else if let postsStory = post.Story {
                fbPostTitleLabel.text = postsStory
            }
            
            if let message = post.Message {
                fbPostLabel.text = message
            }
            
            backgroundColor = UIColor.blackColor()
            
            if let created = post.CreatedTime {
                let date = NSDate(fromInternetDateTimeString: post.CreatedTime, formatHint: DateFormatHintRFC3339)
                fbPostTimeLabel.text = getDateString(date)
            }
        }
    }
    
    private func getDateString (fromDate: NSDate) -> String {
        
        let secondsSince = Int(-fromDate.timeIntervalSinceNow)
        
        let seconds = secondsSince % 60
        let minutes = (secondsSince / 60) % 60
        let hours = secondsSince / 3600
        let strHours = hours > 9 ? String(hours) : String(hours)
        let strMinutes = minutes > 9 ? String(minutes) : String(minutes)
        let strSeconds = seconds > 9 ? String(seconds) : String(seconds)
        
        var returnString = String()
        
        if hours < 1 {
            if minutes == 0 {
                returnString = "Núna"
            } else {
                returnString = "Fyrir \(strMinutes) mínútum"
            }
        } else if hours < 10 {
            if minutes == 0 {
                returnString = "Fyrir \(strHours) klst"
            } else {
                returnString = "Fyrir \(strHours) klst og \(strMinutes) mínútum"
            }
        } else {
            formatter.dateFormat = "dd. MMM yyyy"
            return formatter.stringFromDate(fromDate)
        }
        
        return returnString
        
    }
}
