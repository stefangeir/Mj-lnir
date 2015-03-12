//
//  InstagramMediaCVImageCell.swift
//  Mjölnir
//
//  Created by Stefán Geir on 8.3.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit

class InstagramMediaCVImageCell: UICollectionViewCell
{
    @IBOutlet weak var imageView: UIImageView!
    
    var media: InstagramMedia? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        if let media = media {
            let imageURL = media.standardResolutionImageURL
            imageView.setImageWithURL(imageURL, placeholderImage: UIImage(named: placeholderImageNameString))
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
        }
    }
    
}
