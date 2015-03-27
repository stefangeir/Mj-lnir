//
//  FacebookDataModel.swift
//  Mjölnir
//
//  Created by Stefán Geir on 17.3.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit

struct FacebookNetworking {
    static let FetchedDataNotification = "FacebookDataModel successfully fetched data"
    static let ErrorFetchingDataNotification = "FacebookDataModel error while fetching data"
}

class FacebookDataModel: NSObject
{
    var jsonDataArray = [JSON]()
    var paginationNext: String?
    var retryCount = 0
    var currentRequest: FBSDKGraphRequestConnection?
    
    func reset() {
        currentRequest?.cancel()
        jsonDataArray.removeAll(keepCapacity: true)
        paginationNext = nil
        retryCount = 0
    }
    
    func performRequest() {
        var requestPath = "mjolnir.mmaclub/posts?fields=picture,description,caption,story,message,created_time,id,name"
        var isInitialFetch = true
        
        if paginationNext != nil {
            requestPath = paginationNext!
            isInitialFetch = false
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var request = FBSDKGraphRequest(graphPath: requestPath, parameters: nil)
        
        currentRequest?.cancel()
        currentRequest = FBSDKGraphRequestConnection()
        currentRequest?.addRequest(request, completionHandler: { [unowned self] (connection, data, error) -> Void in
            if error == nil {
                
                self.retryCount = 0
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let jsonData = JSON(data)
                let center = NSNotificationCenter.defaultCenter()
                
                if let posts = jsonData["data"].array {
                    
                    if isInitialFetch {
                        self.jsonDataArray.removeAll(keepCapacity: true)
                    }
                    //println(posts)
                    self.jsonDataArray += posts
                    center.postNotificationName(FacebookNetworking.FetchedDataNotification, object: self)
                }
                if let paginationPath = jsonData["paging"]["next"].string {
                    let delimeter = "https://graph.facebook.com/v2.3/"
                    self.paginationNext = paginationPath.componentsSeparatedByString(delimeter).last
                }
                
                
            } else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let center = NSNotificationCenter.defaultCenter()
                center.postNotificationName(FacebookNetworking.ErrorFetchingDataNotification, object: self, userInfo: ["Error": error])
            }
        })
        currentRequest?.start()
    }
    
//        FBSDKGraphRequestConnection.startWithGraphPath(requestPath, completionHandler: { [unowned self] response, data, error in
//            if error == nil {
//
//                self.retryCount = 0
//                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//                let jsonData = JSON(data)
//                let center = NSNotificationCenter.defaultCenter()
//                
//                if let posts = jsonData["posts"]["data"].array {
//                    if isInitialFetch {
//                        self.jsonDataArray.removeAll(keepCapacity: true)
//                    }
//                    println(posts)
//                    self.jsonDataArray += posts
//                    center.postNotificationName(FacebookNetworking.FetchedDataNotification, object: self)
//                    
//                } else if let posts = jsonData["data"].array {
//                    
//                    if isInitialFetch {
//                        self.jsonDataArray.removeAll(keepCapacity: true)
//                    }
//                    
//                    self.jsonDataArray += posts
//                    center.postNotificationName(FacebookNetworking.FetchedDataNotification, object: self)
//                }
//                if let paginationPath = jsonData["posts"]["paging"]["next"].string {
//                    let delimeter = "https://graph.facebook.com/v2.2/"
//                    self.paginationNext = paginationPath.componentsSeparatedByString(delimeter).last
//                } else if let paginationPath = jsonData["paging"]["next"].string {
//                    let delimeter = "https://graph.facebook.com/v2.2/"
//                    self.paginationNext = paginationPath.componentsSeparatedByString(delimeter).last
//                }
//                
//                
//            } else {
//                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//                let center = NSNotificationCenter.defaultCenter()
//                center.postNotificationName(FacebookNetworking.ErrorFetchingDataNotification, object: self, userInfo: ["Error": error])
//            }
//        })
//    }
    
//    func checkForNewPosts() -> Bool {
//        var thereAreNewPosts = false
//        let requestPath = "Mjolnir.MMAclub?fields=posts.limit(1)"
//        
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//        lastRequestConnection = FBRequestConnection()
//        let request = FBRequest(forGraphPath: requestPath)
//        
//        lastRequestConnection!.addRequest(request, completionHandler: { [unowned self] response, data, error in
//            if error == nil {
//                self.retryCount = 0
//                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//                var jsonData = JSON(data)
//                
//
//                if let posts = jsonData["posts"]["data"].array {
//                    posts
//                    
//                } else if let posts = jsonData["data"].array {
//                    post += posts
//                }
//                
//                
//            } else {
//                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//                let center = NSNotificationCenter.defaultCenter()
//                center.postNotificationName(FacebookNetworking.ErrorFetchingDataNotification, object: self, userInfo: ["Error": error])
//            }
//        })
//        lastRequestConnection!.start()
//        
//        return thereAreNewPosts
//    }
}
