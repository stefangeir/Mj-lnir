//
//  instagramCVC.swift
//  Mjölnir
//
//  Created by Stefán Geir on 23.2.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit



class InstagramCVC: UICollectionViewController {

    let loginSegueString = "segue.login"
    let showMediaSegueString = "segue.showMedia"
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func userOrHashtag(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loadMjolnir = true
        } else if sender.selectedSegmentIndex == 1 {
            loadMjolnir = false
        }
    }
    
    func login(sender: UIBarButtonItem) {
        performSegueWithIdentifier(loginSegueString, sender: self)
    }
    
    var loadMjolnir: Bool = true {
        willSet {
            datasource = InstagramCVDatasource()
            datasource.loadMjolnir = newValue
            datasource.controller = self
            collectionView?.dataSource = datasource
        }
    }
    var youMustLoginView = UILabel()
    var datasource = InstagramCVDatasource()
    var delegate = InstagramCVDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource.controller = self
        datasource.loadMjolnir = loadMjolnir
        collectionView?.dataSource = datasource
        collectionView?.delegate = delegate
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = getItemSize()
        }
    }
    
    func getItemSize() -> CGSize {
        
        var width = UIScreen.mainScreen().bounds.size.width/3 - 1
        
        if UIScreen.mainScreen().bounds.size.width > 750 {
            width = UIScreen.mainScreen().bounds.size.width/6 - 3
        } else if UIScreen.mainScreen().bounds.size.width > 415 {
            width = UIScreen.mainScreen().bounds.size.width/5 - 2
        } else if UIScreen.mainScreen().bounds.size.width > 380 {
            width = UIScreen.mainScreen().bounds.size.width/4 - 1.5
        }
        
        return CGSize(width: width, height: width)
        
    }
    
    func updateLoginButton() {
        if !NSUserDefaults.standardUserDefaults().boolForKey("MjolnirInstagramAPIAuthenticated") {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: UIBarButtonItemStyle.Plain, target: self, action: "login:")
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
        }
    }
    
    func refresh() {
        datasource = InstagramCVDatasource()
        datasource.loadMjolnir = loadMjolnir
        datasource.controller = self
        collectionView?.dataSource = datasource
    }
    
    func showYouMustLoginView(yes: Bool) {
        
        if yes {
            youMustLoginView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            youMustLoginView.text = "Skráðu þig inn með Instagram. Login takkinn er uppi hægra megin"
            youMustLoginView.textColor = UIColor.whiteColor()
            youMustLoginView.textAlignment = NSTextAlignment.Center
            youMustLoginView.numberOfLines = 0
            
            let x: CGFloat = 0.0
            let y = UIScreen.mainScreen().bounds.height/5
            let width = UIScreen.mainScreen().bounds.width
            let height: CGFloat = 100
            youMustLoginView.frame = CGRectMake(x, y, width, height)
            
            collectionView?.addSubview(youMustLoginView)
            collectionView?.bringSubviewToFront(youMustLoginView)
        } else {
            if youMustLoginView.superview != nil {
                youMustLoginView.removeFromSuperview()
                youMustLoginView = UILabel()
            }
        }
    }

    
    func updateData() {
        datasource.loadMedia()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == loginSegueString {
            if let nav = segue.destinationViewController as? UINavigationController {
                if let webVC = nav.viewControllers.first as? InstagramLoginWebViewController {
                    webVC.collectionVC = self
                }
            }
        }
        
        if segue.identifier == showMediaSegueString {
            if let instagramMedia = segue.destinationViewController as? InstagramMediaCVC {
                if let cell = sender as? InstagramCVCell {
                    let indexPath = collectionView!.indexPathForCell(cell)
                    instagramMedia.media = datasource.mediaArray[indexPath!.row]
                    navigationController?.navigationBarHidden = false
                    navigationController?.hidesBarsOnSwipe = false
                }
                
            }
            
        }
    }
    

}
