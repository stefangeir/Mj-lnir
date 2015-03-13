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
    
    @IBOutlet var fbPostLabel: UILabel!
    @IBOutlet var fbPostTimeLabel: UILabel!
    @IBOutlet var fbPostImageView: UIImageView!
    
    var post: fbPost? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        // reset old info
        fbPostLabel?.text = nil
        fbPostLabel?.attributedText = nil
        fbPostTimeLabel?.text = nil
        fbPostImageView?.image = nil
        
        //fbPostImageView.contentMode = UIViewContentMode.ScaleAspectFit
        if let post = self.post {
            if post.pictureUrl != nil {
                let url = NSURL(string: post.pictureUrl!)
                fbPostImageView.setImageWithURL(url, placeholderImage: UIImage(named: placeholderImageNameString))
            } else {
                fbPostImageView.image = UIImage(named: placeholderImageNameString)
            }
            
            if let message = post.message {
                fbPostLabel.text = message
            } else {
                fbPostLabel.text = " "
            }
            backgroundColor = UIColor.blackColor()
            let date = NSDate(fromInternetDateTimeString: post.date, formatHint: DateFormatHintRFC3339)
            fbPostTimeLabel.text = getDateString(date)
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
