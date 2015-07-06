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
            if couldExtractImageURL(item.summary) {
                if let url = extractedImageURL {
                    myImageView.setImageWithURL(url, placeholderImage: UIImage(named: placeholderImageNameString))
                }
            }
        }
        backgroundColor = UIColor.blackColor()
    }
    
    var extractedImageURL: NSURL?
    
    func couldExtractImageURL(fromString: String) -> Bool
    {
        var imageString = String()
        var stringArray = fromString.componentsSeparatedByString("<p><img src=\"")
        
        if stringArray.count > 1 {
            imageString = fromString.componentsSeparatedByString("<p><img src=\"")[1]
            if imageString.lowercaseString.rangeOfString(".jpg") != nil {
                stringArray = imageString.componentsSeparatedByString(".jpg")
                if let imageURL = stringArray.first {
                    extractedImageURL = NSURL(string: imageURL + ".jpg")
                    return true
                }
            } else if imageString.lowercaseString.rangeOfString(".png") != nil {
                stringArray = imageString.componentsSeparatedByString(".png")
                if let imageURL = stringArray.first {
                    extractedImageURL = NSURL(string: imageURL + ".png")
                    return true
                }
            }
        }
        return false
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
