//
//  InstagramMediaCVLikesCell.swift
//  Mjölnir
//
//  Created by Stefán Geir on 8.3.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit

class InstagramMediaCVLikesCell: UICollectionViewCell {
    @IBOutlet weak var likesLabel: UILabel!
    
    var numberOfLikes: Int? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        if let numberOfLikes = numberOfLikes {
            var textLabelString = String()
            
            if numberOfLikes == 1 {
                textLabelString = "♥︎ \(numberOfLikes) like"
            } else {
                textLabelString = "♥︎ \(numberOfLikes) likes"
            }
            
            likesLabel.attributedText = NSAttributedString(string: textLabelString, attributes: InstagramFontsAndAttributes.LikesAttributes)
        }
    }
}
