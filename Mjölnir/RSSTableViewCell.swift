//
//  RSSTableViewCell.swift
//  Mjölnir
//
//  Created by Stefán Geir Sigfússon on 15.2.2015.
//  Copyright (c) 2015 Stefán Geir. All rights reserved.
//

import UIKit

class RSSTableViewCell: UITableViewCell
{
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var timeLabel: UILabel!
	@IBOutlet var myImageView: UIImageView!
	
    var item: MWFeedItem? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        titleLabel.text = nil
        timeLabel.text = nil
        myImageView.image = nil
        
        if let item = item {
            titleLabel.text = item.title
            timeLabel.text = getDateString(item.date)
            myImageView.setImageWithURL(getImageURLFromString(item.summary), placeholderImage: UIImage(named: placeholderImageNameString))
        }
        backgroundColor = UIColor.blackColor()
        
    }
    
    func getImageURLFromString (fromString: String) -> NSURL {
        
        var imageString = String()
        
        imageString = fromString.componentsSeparatedByString("<p><img src=\"")[1]
        imageString = imageString.componentsSeparatedByString(".jpg")[0]
        imageString += ".jpg"
        
        return NSURL(string: imageString)!
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
