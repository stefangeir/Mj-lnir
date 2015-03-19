//
//  instagramMediaCVDatasource.swift
//  Mjölnir
//
//  Created by Stefán Geir on 7.3.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit

class instagramMediaCVDatasource: NSObject, UICollectionViewDataSource
{
    weak var controller: InstagramMediaCVC?
    var media = InstagramMedia()
    
    let imageReuseIdentifier = "reusable.instagramMediaImageCell"
    let commentReuseIdentifier = "reusable.commentCell"
    let likesReuseIdentifier = "reusable.likesCell"
    let dateReuseIdentifier = "reusable.dateCell"
    let videoReuseIdentifier = "reusable.instagramMediaVideoCell"
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // 1: Image 2: caption and comments
        
        if media.caption.text != nil {
            return 4 + media.comments.count // date + image + likes + caption + comments
        } else {
            return 3 + media.comments.count // date + image + likes + comments
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(dateReuseIdentifier, forIndexPath: indexPath) as InstagramMediaCVDateCell
            cell.dateString = getDateString(media.createdDate)
            return cell
        }
        else if indexPath.section == 1 {
            
            if media.isVideo {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(videoReuseIdentifier, forIndexPath: indexPath) as InstagramMediaCVVideoCell
                cell.media = media
                return cell
            } else {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(imageReuseIdentifier, forIndexPath: indexPath) as InstagramMediaCVImageCell
                cell.media = media
                return cell
            }
            
        } else if indexPath.section == 2 {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(likesReuseIdentifier, forIndexPath: indexPath) as InstagramMediaCVLikesCell
            
            cell.numberOfLikes = media.likesCount
            return cell
        }
            
        else if indexPath.section == 3 && media.caption.text != nil {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(commentReuseIdentifier, forIndexPath: indexPath) as InstagramMediaCVCommentCell
            
            cell.isCaption = true
            cell.comment = media.caption
            
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(commentReuseIdentifier, forIndexPath: indexPath) as InstagramMediaCVCommentCell
            
            var row = indexPath.section - 3 // -3 because of date, image, likes
            if media.caption.text != nil {
                row -= 1 // -4 now because date, image, likes, caption
            }
            
            cell.comment = media.comments[row] as? InstagramComment
            return cell
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
    
    func playbackStateChanged() {
        if let cell = controller?.collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 1)) as? InstagramMediaCVVideoCell {
            cell.playbackStateChanged()
        }
    }
    
    func stopVideo() {
        if let cell = controller?.collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 1)) as? InstagramMediaCVVideoCell {
            if let player = cell.player {
                player.stop()
                cell.showVideoIcon()
            }
        }
    }
    
    
}
