//
//  instagramMediaCommentCVCell.swift
//  Mjölnir
//
//  Created by Stefán Geir on 25.2.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import InstagramKit
import UIKit

class InstagramMediaCVCommentCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    
    var comment: InstagramComment? {
        didSet {
            updateUI()
        }
    }
    var isCaption = false
    
    func updateUI() {
        // username
        if let comment = comment {
            var captionSymbol = ""
            if isCaption {
                captionSymbol = "💬 "
            }
            var textLabelAttributedString = NSMutableAttributedString(string: captionSymbol + comment.user.username + " ", attributes: InstagramFontsAndAttributes.UsernameAttributes)
            // caption
            textLabelAttributedString.appendAttributedString(NSAttributedString(string: comment.text, attributes: InstagramFontsAndAttributes.CommentAttributes))
            
            textLabel.attributedText = textLabelAttributedString
        }
    }
}
