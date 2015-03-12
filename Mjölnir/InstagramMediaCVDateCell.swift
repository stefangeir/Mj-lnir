//
//  InstagramMediaCVDateCell.swift
//  Mjölnir
//
//  Created by Stefán Geir on 8.3.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit

class InstagramMediaCVDateCell: UICollectionViewCell
{
    @IBOutlet weak var dateLabel: UILabel!
    
    var dateString: String? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        if let dateString = dateString {
            dateLabel.attributedText = NSAttributedString(string: dateString, attributes: InstagramFontsAndAttributes.DateAttributes)
        }
    }
}
