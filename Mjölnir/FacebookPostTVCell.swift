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
            
            fbPostTitleLabel.text = post.Title
            fbPostLabel.text = post.Message
            
            backgroundColor = UIColor.blackColor()
            fbPostTimeLabel.text = post.CreatedTime
        }
    }
}
