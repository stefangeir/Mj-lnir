//
//  MjolnirCVCDelegate.swift
//  MjolnirMisc
//
//  Created by Stefán Geir Sigfússon on 18.2.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit

class MainCVCDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    weak var controller: MainCVC?
    let screenSize = UIScreen.mainScreen().bounds.size
    let insetForBusinessDays = UIEdgeInsets(top: 7, left: 5, bottom: 0, right: 5)
    var insetForWeekendDays: UIEdgeInsets {
        get {
            if let controller = controller {
                if let layout = controller.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                    var used = layout.minimumInteritemSpacing
                    used += sizeForTimetableButtons.width * 2
                    var unused = screenSize.width - used
                    return UIEdgeInsets(top: 7, left: unused/2, bottom: 0, right: unused/2)
                }
            }
            return insetForOther
        }
    }
    var insetForToday: UIEdgeInsets {
        get {
            if let controller = controller {
                if let layout = controller.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                    var used = sizeForTimetableButtons.width
                    var unused = screenSize.width - used
                    return UIEdgeInsets(top: 7, left: unused/2, bottom: 7, right: unused/2)
                }
            }
            return insetForOther
        }
    }
    
    var insetForOther: UIEdgeInsets {
        get {
            let t: CGFloat = screenSize.height/30
            let l: CGFloat = screenSize.width/9
            let b: CGFloat = screenSize.height/10
            let r: CGFloat = screenSize.width/9
        
            return UIEdgeInsets(top: t, left: l, bottom: b, right: r)
        }
    }
    
    var sizeForTimetableButtons: CGSize {
        get {
            if let controller = controller {
                if let layout = controller.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                    var used = layout.minimumInteritemSpacing * 4 + insetForBusinessDays.left + insetForBusinessDays.right
                    var unused = screenSize.width - used
                    var sizeForEachButton = unused / 5
                    if sizeForEachButton > 100 {
                        return CGSize(width: 100, height: 100)
                    } else {
                        return CGSize(width: unused/5, height: unused/5)
                    }
                }
            }
            return sizeForOtherButtons
        }
    }
    let sizeForOtherButtons = CGSize(width: 50, height: 40)
    let spacingForTimetableButtons: CGFloat = 5
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        switch section {
        case WeekdaySelectSectionNumbers.businessDays:
            if sizeForTimetableButtons == CGSize(width: 100, height: 100) {
                var used = sizeForTimetableButtons.width * 5
                if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
                    used += layout.minimumInteritemSpacing * 4
                    var unused = screenSize.width - used
                    return UIEdgeInsets(top: 7, left: unused/2, bottom: 0, right: unused/2)
                }
            }
            return insetForBusinessDays
        case WeekdaySelectSectionNumbers.weekendDays:
            return insetForWeekendDays
        case WeekdaySelectSectionNumbers.today:
            return insetForToday
        default:
            return insetForOther
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            var usedHeight: CGFloat = 0
            if let controller = controller {
                if let nc = controller.navigationController {
                    if nc.navigationBarHidden == false {
                        usedHeight += nc.navigationBar.frame.size.height
                    }
                    usedHeight += UIApplication.sharedApplication().statusBarFrame.height
                }
                if let tbc = controller.tabBarController {
                    usedHeight += tbc.tabBar.frame.size.height
                }
            }
            
            usedHeight += insetForBusinessDays.top + insetForBusinessDays.bottom + insetForWeekendDays.top + insetForWeekendDays.bottom + insetForToday.top + insetForToday.bottom
            usedHeight += sizeForTimetableButtons.height * 3
            var unusedHeight = screenSize.height - usedHeight
            
            return CGSize(width: screenSize.width, height: unusedHeight)
        }
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
            return sizeForTimetableButtons

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
                return spacingForTimetableButtons
    }

	
}
