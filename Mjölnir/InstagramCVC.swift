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
    
    var loadMjolnir: Bool = true {
        didSet {
            refresh()
        }
    }

    var datasource = InstagramCVDatasource()
    var delegate = InstagramCVDelegate()
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource.controller = self
        datasource.datamodel.loadMjolnir = loadMjolnir
        collectionView?.dataSource = datasource
        collectionView?.delegate = delegate
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            (layout.itemSize, layout.minimumInteritemSpacing, layout.minimumLineSpacing) = getItemSizeAndSpacing()
        }
        updateLoginButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let center = NSNotificationCenter.defaultCenter()
        
        center.addObserver(datasource, selector: "mediaWasFetched", name: InstagramNetworking.FetchedInstagramDataNotification, object: nil)
        center.addObserver(datasource, selector: "userLoggedIn", name: InstagramNetworking.UserDidLogin, object: nil)
        center.addObserver(datasource, selector: "userLoggedOut", name: InstagramNetworking.UserDidLogout, object: nil)
        center.addObserver(self, selector: "errorFetchingMedia:", name: InstagramNetworking.ErrorFetchingInstagramDataNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(datasource)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func errorFetchingMedia(note: NSNotification) {
        
        if let errorDict = note.userInfo as? [String : NSError] {
            if let error = errorDict["Error"] {
                let alertController = UIAlertController(title: "Vesen: ", message:
                    error.localizedDescription, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Flott", style: .Default,handler: nil))
                
                presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    func getItemSizeAndSpacing() -> (CGSize, CGFloat, CGFloat) {
        
        // Get pixels per point and screenWidth
        let scaleFactor = UIScreen.mainScreen().scale
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let spacingInPixels: CGFloat = 3
        
        // 3 images across, need 1 pixel spacing twice = 0.5 points twice = 2/scaleFactor = 2/2 = 1
        var numberOfImagesAcross: CGFloat  = 3
        var sumOfSpacingNeeded: CGFloat = 2 * spacingInPixels / scaleFactor
        
        var itemWidth: CGFloat
        
        if screenWidth > 750 {
            numberOfImagesAcross = 6
            sumOfSpacingNeeded = 5 * spacingInPixels / scaleFactor
        } else if screenWidth > 415 {
            numberOfImagesAcross =  5
            sumOfSpacingNeeded = 4 * spacingInPixels / scaleFactor
        } else if screenWidth > 380 {
            numberOfImagesAcross = 4
            sumOfSpacingNeeded = 3 * spacingInPixels / scaleFactor
        }
        
        itemWidth = (screenWidth / numberOfImagesAcross) - (sumOfSpacingNeeded / numberOfImagesAcross)
        
        let lineAndCellSpacing = spacingInPixels / scaleFactor
        
        return (CGSize(width: itemWidth, height: itemWidth), lineAndCellSpacing, lineAndCellSpacing)
        
    }

    func refresh() {
        datasource.datamodel.reset()
        datasource.datamodel.loadMjolnir = loadMjolnir
        datasource.datamodel.fetchMedia()
    }
    
    //MARK: - Login related
   
    func updateLoginButton() {
        if !NSUserDefaults.standardUserDefaults().boolForKey("MjolnirInstagramAPIAuthenticated") {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .Plain, target: self, action: "login:")
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refresh")
        }
    }

    
    func showYouMustLoginView(yes: Bool) {
        
        if yes {
            collectionView?.addSubview(youMustLoginView)
            collectionView?.bringSubviewToFront(youMustLoginView)
        } else {
            if youMustLoginView.superview != nil {
                youMustLoginView.removeFromSuperview()
            }
        }
    }
    
    lazy var youMustLoginView: UILabel = {
        var label = UILabel()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        label.text = "Skráðu þig inn með Instagram. Login takkinn er uppi hægra megin"
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 0
        let x: CGFloat = 0.0
        let y = UIScreen.mainScreen().bounds.height/5
        let width = UIScreen.mainScreen().bounds.width
        let height: CGFloat = 100
        label.frame = CGRectMake(x, y, width, height)
        return label
        }()
    
    
    func login(sender: UIBarButtonItem) {
        performSegueWithIdentifier(loginSegueString, sender: self)
    }
    
    var userDenied = false
    
    @IBAction func userLoggedIn(segue: UIStoryboardSegue) {
        if !userDenied {
            refresh()
        }
    }
    
    //MARK: - Segue to media
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showMediaSegueString {
            if let instagramMedia = segue.destinationViewController as? InstagramMediaCVC {
                if let cell = sender as? InstagramCVCell {
                    let indexPath = collectionView!.indexPathForCell(cell)
                    instagramMedia.media = datasource.datamodel.data[indexPath!.row]
                }
            }
        }
    }
    

}
