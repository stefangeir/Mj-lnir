//
//  MjolnirCVCDatasource.swift
//  MjolnirMisc
//
//  Created by Stefán Geir Sigfússon on 18.2.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit

class MainCVCDatasource: NSObject, UICollectionViewDataSource
{
    
    var buttons = [Int:[String]]()
    let buttonReuseIdentifier = "reusable.buttonCell"
    let sectionReuseIdentifier = "reusable.MainViewSectionHeader"

	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		
        return buttons.keys.array.count
	}

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = buttons[section]?.count {
            return count
        }
        return 0
    }
    
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(buttonReuseIdentifier, forIndexPath: indexPath) as MainCVCell
        
        cell.text = buttons[indexPath.section]![indexPath.row]
		return cell
	}
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
            withReuseIdentifier: sectionReuseIdentifier,
            forIndexPath: indexPath) as MainCVSectionHeader
        
        // Parallax effects
        var verticalMotionEffect : UIInterpolatingMotionEffect =
        UIInterpolatingMotionEffect(keyPath: "center.y",
            type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -20
        verticalMotionEffect.maximumRelativeValue = 10
        var horizontalMotionEffect : UIInterpolatingMotionEffect =
        UIInterpolatingMotionEffect(keyPath: "center.x",
            type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -20
        horizontalMotionEffect.maximumRelativeValue = 20
        var group : UIMotionEffectGroup = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        headerView.addMotionEffect(group)
        return headerView
    }
	
}
