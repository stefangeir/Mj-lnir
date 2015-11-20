//
//  instagramMediaCVC.swift
//  
//
//  Created by Stefán Geir on 25.2.2015.
//
//

import InstagramKit
import UIKit
import MediaPlayer

struct InstagramFontsAndAttributes {
    static let DateFont = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
    static let UsernameFont = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline).fontWithSize(UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1).pointSize)
    static let CommentFont = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
    
    static let DateAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)]
    static let UsernameAttributes = [NSForegroundColorAttributeName:UIColor.redColor(),
        NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline).fontWithSize(UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1).pointSize)]
    static let CommentAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(),
        NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)]
    static let LikesAttributes = InstagramFontsAndAttributes.UsernameAttributes
}

class InstagramMediaCVC: UICollectionViewController {
    
    @IBAction func viewInAppButton(sender: UIBarButtonItem) {
        
        let appurl = NSURL(string: "instagram://media?id=" + media.Id)
        if UIApplication.sharedApplication().canOpenURL(appurl!) {
            UIApplication.sharedApplication().openURL(appurl!)
        } else {
            let alertController = UIAlertController(title: nil, message:
                "Þessi takki virkar bara ef þú ert með Instagram appið", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    var datasource = instagramMediaCVDatasource()
    var delegate = instagramMediaCVDelegate()
    var media = InstagramMedia()
    var flowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource.media = media
        delegate.media = media
        datasource.controller = self
        delegate.controller = self
        flowLayout.sectionInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        collectionView?.collectionViewLayout = flowLayout
        collectionView?.dataSource = datasource
        collectionView?.delegate = delegate
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.hidesBarsOnSwipe = false
        if media.isVideo {
            NSNotificationCenter.defaultCenter().addObserver(datasource, selector: "playbackStateChanged", name:MPMoviePlayerPlaybackStateDidChangeNotification, object: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(datasource)
        if media.isVideo {
            datasource.stopVideo()
        }
        navigationController?.hidesBarsOnSwipe = true
    }

}