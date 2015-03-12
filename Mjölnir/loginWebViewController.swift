//
//  loginWebViewController.swift
//  Mjölnir
//
//  Created by Stefán Geir on 23.2.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit


class loginWebViewController: UIViewController, UIWebViewDelegate
{
    @IBOutlet weak var webView: UIWebView!

    @IBAction func back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var collectionVC: instagramCVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        
        let sharedEngine = InstagramEngine.sharedEngine()

        let configuration = InstagramEngine.sharedEngineConfiguration()
        println("\(sharedEngine.authorizationURL)?client_id=\(sharedEngine.appClientID)&redirect_uri=\(sharedEngine.appRedirectURL)&response_type=token")
        let url = NSURL(string: "\(sharedEngine.authorizationURL)?client_id=\(sharedEngine.appClientID)&redirect_uri=\(sharedEngine.appRedirectURL)&response_type=token")
        webView.loadRequest(NSURLRequest(URL: url!))
        
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var URLString = request.URL.absoluteString
        
        if URLString!.hasPrefix(InstagramEngine.sharedEngine().appRedirectURL) {
        
        var delimeter = "access_token="
        var components = URLString?.componentsSeparatedByString(delimeter)
        if components!.count > 1 {
            let accessToken = components!.last
            println("ACCESS TOKEN = \(accessToken)")
            
            NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "MjolnirInstagramAccessToken")
            NSUserDefaults.standardUserDefaults().synchronize()

            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                if self.collectionVC != nil {
                    self.collectionVC!.updateData()
                }
            })
            }
            return false
        }
        return true
    }
}