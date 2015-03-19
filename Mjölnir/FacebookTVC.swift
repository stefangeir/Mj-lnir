//
//  facebookTVC.swift
//  Mjölnir
//
//  Created by Stefán Geir on 21.2.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit

let openInFacebookAppUserDefaultsString = "MjolnirOpenFacebookPostsInFacebookApp"

class FacebookTVC: UITableViewController, FBLoginViewDelegate {
    
    let datasource = FacebookTVDatasource()
    let delegate = FacebookTVDelegate()
    
    var myLoginView: FBLoginView! {
        didSet {
                myLoginView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datasource.controller = self
        delegate.controller = self
        tableView.dataSource = datasource
        tableView.delegate = delegate
        
        // FBLoginView as Header. Footer to hide pointless rows of table
        myLoginView = FBLoginView()
        myLoginView.bounds.size.width = tableView.bounds.size.width
        tableView.tableHeaderView = myLoginView
        tableView.tableHeaderView?.hidden = false
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.tableFooterView?.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let center = NSNotificationCenter.defaultCenter()
        
        center.addObserver(datasource, selector: "parseData", name: FacebookNetworking.FetchedDataNotification, object: nil)
        center.addObserver(datasource, selector: "handleFBError:", name: FacebookNetworking.ErrorFetchingDataNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(datasource)
    }
    
    func refresh() {
        refresh(refreshControl)
    }
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        if userIsLoggedIn {
            refreshControl?.beginRefreshing()
            datasource.refresh()
        } else {
            sender?.endRefreshing()
        }
    }
    

    
    var userIsLoggedIn: Bool = false {
        willSet {
            showYouMustLoginView(!newValue)
        }
    }
    
    //MARK: - FBLoginViewDelegate
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        userIsLoggedIn = true
        refresh()
    }
    
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        userIsLoggedIn = false
        datasource.reset()
        tableView.reloadData()
    }
    
    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        handleAuthError(error)
    }
    
    //MARK: - Error handling
    
    func handleAuthError(error: NSError) {
        var alertText = String()
        var alertTitle = String()
        
        if FBErrorUtility.shouldNotifyUserForError(error) {
            alertTitle = "Eitthvað vesen"
            alertText = FBErrorUtility.userMessageForError(error)
            showMessage(alertText, withTitle: alertTitle)
        } else {
            if FBErrorUtility.errorCategoryForError(error) == FBErrorCategory.UserCancelled {
                alertTitle = "Hætt við innskráningu"
                alertText = "Þú þarft að skrá þig inn til að sjá pósta frá Mjölni"
                showMessage(alertText, withTitle: alertTitle)
            } else if FBErrorUtility.errorCategoryForError(error) == FBErrorCategory.AuthenticationReopenSession {
                alertTitle = "Session error"
                alertText = "Your current session is no longer valid. Please log in again."
                
                showMessage(alertText, withTitle: alertTitle)
            } else {
                alertTitle = "Eitthvað vesen"
                alertText = "Reyndu aftur"
                showMessage(alertText, withTitle: alertTitle)
            }
        }
    }
    
    
    func showMessage(text: String, withTitle: String) {
       let alertController =  UIAlertController(title: withTitle, message: text, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Flott", style: UIAlertActionStyle.Default,handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
        
    }


    
    lazy var youMustLoginView: UILabel = {
        var youMustLoginView = UILabel()
        youMustLoginView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        youMustLoginView.text = "Skráðu þig inn með facebook"
        youMustLoginView.textColor = UIColor.whiteColor()
        youMustLoginView.numberOfLines = 0
        youMustLoginView.textAlignment = NSTextAlignment.Center
        let x: CGFloat = 0.0
        let y = UIScreen.mainScreen().bounds.height/4
        let width = UIScreen.mainScreen().bounds.width
        let height: CGFloat = 60.0
        youMustLoginView.frame = CGRectMake(x, y, width, height)

        return youMustLoginView
    }()
    
    func showYouMustLoginView(yes: Bool) {
        if yes {
            tableView.addSubview(youMustLoginView)
            tableView.bringSubviewToFront(youMustLoginView)
        } else {
            if youMustLoginView.superview != nil {
                youMustLoginView.removeFromSuperview()
            }
        }
    }

    //MARK: - Navigation
    
    var openLinksInFacebookApp: Bool {
        get {
            if let value = NSUserDefaults.standardUserDefaults().objectForKey(openInFacebookAppUserDefaultsString) as? Bool {
                return value
            } else {
                NSUserDefaults.standardUserDefaults().setObject(false, forKey: openInFacebookAppUserDefaultsString)
                NSUserDefaults.standardUserDefaults().synchronize()
                return false
            }
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: openInFacebookAppUserDefaultsString)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    let viewStoryInWebViewSegueString = "segue.viewStoryInWeb"
    
    func selectedRow(indexPath: NSIndexPath) {
        
        let row = indexPath.row
        if row < datasource.fbPosts.count {
            let appUrl = NSURL(string: "fb://story?id=" + datasource.getIdInRow(row))
            if openLinksInFacebookApp && UIApplication.sharedApplication().canOpenURL(appUrl!) {
                UIApplication.sharedApplication().openURL(appUrl!)
            } else {
                performSegueWithIdentifier(viewStoryInWebViewSegueString, sender: tableView.cellForRowAtIndexPath(indexPath))
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == viewStoryInWebViewSegueString {
            if let webVC = segue.destinationViewController as? FacebookWebViewController {
                if let cell = sender as? FacebookPostTVCell {
                    if let row = tableView.indexPathForCell(cell)?.row {
                        webVC.urlString = datasource.getItemLinkInRow(row)
                        webVC.openInAppURL = NSURL(string: "fb://story?id=" + datasource.getIdInRow(row))!
                        navigationController?.setNavigationBarHidden(false, animated: true)
                    }
                }
            }
        }
    }
    
}
