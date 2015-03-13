//
//  MjolnirCVCell.swift
//  MjolnirMisc
//
//  Created by Stefán Geir on 18.2.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit

class MainCVCell: UICollectionViewCell {
    
    @IBOutlet weak var buttonLabel: UILabel!
    
    var text: String? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        if let text = text {
            selectedBackgroundView = UIView(frame: bounds)
            selectedBackgroundView.backgroundColor = UIColor.redColor()
            buttonLabel?.text = text
            layer.cornerRadius = frame.size.height/2
            layer.borderColor = UIColor.redColor().CGColor
            layer.borderWidth = 1
            backgroundColor = UIColor.clearColor()
        }
    }
    
}
