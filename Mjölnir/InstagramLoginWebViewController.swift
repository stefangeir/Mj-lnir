//
//  loginWebViewController.swift
//  Mjölnir
//
//  Created by Stefán Geir on 23.2.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit

class InstagramLoginWebViewController: UIViewController, UIWebViewDelegate
{
    let userLoggedInSegueString = "segue.userLoggedInToInstagram"
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        let sharedEngine = InstagramEngine.sharedEngine()
        let configuration = InstagramEngine.sharedEngineConfiguration()
        let url = NSURL(string: "\(sharedEngine.authorizationURL)?client_id=\(sharedEngine.appClientID)&redirect_uri=\(sharedEngine.appRedirectURL)&response_type=token")
        webView.loadRequest(NSURLRequest(URL: url!))
        
    }
    
    var userDenied = false
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var URLString = request.URL.absoluteString
        
        if URLString!.hasPrefix(InstagramEngine.sharedEngine().appRedirectURL) {
            
            var delimeter = "access_token="
            var components = URLString?.componentsSeparatedByString(delimeter)
            if components!.count > 1 {
                let accessToken = components!.last
                
                NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "MjolnirInstagramAccessToken")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                performSegueWithIdentifier(userLoggedInSegueString, sender: self)
            } else {
                // User denied access
                delimeter = "access_denied"
                components = URLString?.componentsSeparatedByString(delimeter)
                if components!.count > 0 {
                    userDenied = true
                    performSegueWithIdentifier(userLoggedInSegueString, sender: self)
                }
            }
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == userLoggedInSegueString {
            if let cv = segue.destinationViewController as? InstagramCVC {
                cv.userDenied = userDenied
            }
        }
    }
}