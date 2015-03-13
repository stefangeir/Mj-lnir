//
//  instagramCVCell.swift
//  Mjölnir
//
//  Created by Stefán Geir on 23.2.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit

class InstagramCVCell: UICollectionViewCell {
    
    @IBOutlet weak var videoIcon: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var caption: UILabel!
    
    var media: InstagramMedia? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        // reset any existing information
        imageView?.image = nil
        caption?.text = nil
        
        // load new information (if any)
        
        if let media = self.media {
            imageView.setImageWithURL(media.thumbnailURL, placeholderImage: UIImage(named: placeholderImageNameString))
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            caption.text = media.caption.text
            caption.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
            caption.textColor = UIColor.whiteColor()
            
            if media.isVideo {
                videoIcon.hidden = false
                videoIcon.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
            } else {
                videoIcon.hidden = true
            }
        }
    }
}
