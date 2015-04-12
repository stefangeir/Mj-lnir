//
//  instagramCVDatasource.swift
//  Mjölnir
//
//  Created by Stefán Geir on 23.2.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit



class InstagramCVDatasource: NSObject, UICollectionViewDataSource
{
    weak var controller: InstagramCVC!
    var datamodel = InstagramDataModel()
    
    // MARK: - Notification Actions
    
    func mediaWasFetched() {
        controller.collectionView?.reloadData()
    }
    
    func userLoggedIn() {
        controller.updateLoginButton()
        controller.showYouMustLoginView(false)
    }
    
    func userLoggedOut() {
        controller.updateLoginButton()
        controller.showYouMustLoginView(true)
    }
    
    //MARK: - Datasource methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !datamodel.reachedEndOfFeed {
            return datamodel.data.count + 1 // + 1 fyrir loading cellu
        } else {
            return datamodel.data.count
        }
    }
    
    private struct Storyboard {
        static let InstagramImageCellReuseIdentifier = "reusable.instagramImageCell"
        static let LoadingCellReuseIdentifier = "reusable.instagramCVLoadingCell"
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.row < datamodel.data.count {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.InstagramImageCellReuseIdentifier, forIndexPath: indexPath) as! InstagramCVCell
            
            cell.media = datamodel.data[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.LoadingCellReuseIdentifier, forIndexPath: indexPath) as! InstagramCVLoadingCell
            
            cell.backgroundColor = UIColor.clearColor()
            cell.label.textColor = UIColor.whiteColor()
            
            if datamodel.userIsLoggedIn {
                datamodel.fetchMedia()
            } else {
                cell.label.text = ""
            }
            
            return cell
            
        }
    }
}
