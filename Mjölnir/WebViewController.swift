//
//  WebViewController.swift
//  Mjölnir
//
//  Created by Stefán Geir Sigfússon on 15.2.2015.
//  Copyright (c) 2015 Stefán Geir. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

	@IBOutlet weak var webView: UIWebView!
	
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
