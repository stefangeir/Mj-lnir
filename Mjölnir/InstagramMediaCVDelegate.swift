//
//  instagramMediaCVDelegate.swift
//  Mjölnir
//
//  Created by Stefán Geir on 7.3.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit

class instagramMediaCVDelegate: NSObject, UICollectionViewDelegate
{
    weak var controller: InstagramMediaCVC?
    var media = InstagramMedia()
    let padding: CGFloat = 10
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let usernameFont = InstagramFontsAndAttributes.UsernameFont
        let dateFont = InstagramFontsAndAttributes.DateFont
        let commentFont = InstagramFontsAndAttributes.CommentFont
        let usernameAttributes = InstagramFontsAndAttributes.UsernameAttributes
        let dateAttributes = InstagramFontsAndAttributes.DateAttributes
        let commentAttributes = InstagramFontsAndAttributes.CommentAttributes
        
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        var screenWidthMinusPadding = screenWidth - 2 * padding
        
        if indexPath.section == 0 {
            var heightMeasurementAttributedString = NSAttributedString(string: "JFMAMSOND 1234567890", attributes: dateAttributes)
            return CGSize(width: screenWidth, height: heightMeasurementAttributedString.size().height)
        } else if indexPath.section == 1 {
            return CGSize(width: screenWidth, height: screenWidth)
        } else if indexPath.section == 2 {
            // likes
            return CGSize(width: screenWidthMinusPadding, height: usernameFont.pointSize)
            
        } else if indexPath.section == 3  && media.caption.text != nil{
            // caption
            var textLabelAttributedString = NSMutableAttributedString(string:"💬 " + media.caption.user.username + " ", attributes: usernameAttributes)
            textLabelAttributedString.appendAttributedString(NSAttributedString(string: media.caption.text, attributes: commentAttributes))
            let myOptions: NSStringDrawingOptions = unsafeBitCast(NSStringDrawingOptions.UsesLineFragmentOrigin.rawValue,
                NSStringDrawingOptions.self)
            let labelBounds = textLabelAttributedString.boundingRectWithSize(CGSize(width: screenWidthMinusPadding, height: 9999),
                options: myOptions,
                context: nil)
            
            return CGSize(width: screenWidthMinusPadding , height: ceil(labelBounds.size.height))
        } else {
            // comment
            
            var row = indexPath.section - 3 // -3 because of date, image, likes
            if media.caption.text != nil {
                row -= 1 // - 4 now because of date, image, likes and caption
            }
            
            let comment = media.comments[row] as! InstagramComment
            
            var textLabelAttributedString = NSMutableAttributedString(string:"" + comment.user.username + " ", attributes: usernameAttributes)
            
            textLabelAttributedString.appendAttributedString(NSAttributedString(string: comment.text, attributes: commentAttributes))
            let myOptions: NSStringDrawingOptions = unsafeBitCast(NSStringDrawingOptions.UsesLineFragmentOrigin.rawValue,
                NSStringDrawingOptions.self)
            let labelBounds = textLabelAttributedString.boundingRectWithSize(CGSize(width: screenWidthMinusPadding, height: 9999),
                options: myOptions,
                context: nil)
            return CGSize(width: screenWidthMinusPadding, height: ceil(labelBounds.size.height))
        }
    }
}
