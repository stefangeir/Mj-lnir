//
//  FacebookWebViewController.swift
//  Mjölnir
//
//  Created by Stefán Geir on 11.3.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit

class FacebookWebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBAction func openInApp(sender: UIBarButtonItem) {
       if UIApplication.sharedApplication().canOpenURL(openInAppURL) {
            UIApplication.sharedApplication().openURL(openInAppURL)
        }
        
    }
    
    var openInAppURL = NSURL()
    
    var urlString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getContent()
    }
    
    func getContent() {
        
        let url = NSURL(string: urlString)
        var request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}