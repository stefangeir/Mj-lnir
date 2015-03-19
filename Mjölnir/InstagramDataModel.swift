//
//  InstagramDataModel.swift
//  Mjölnir
//
//  Created by Stefán Geir on 19.3.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit

struct InstagramNetworking {
    static let UserDidLogin = "User Is Logged In"
    static let UserDidLogout = "User Was Logged Out"
    static let FetchedInstagramDataNotification = "Fetched Instagram Data"
    static let ErrorFetchingInstagramDataNotification = "Error Fetching Instagram Data"
}

class InstagramDataModel: NSObject
{
    var reachedEndOfFeed = false
    var loadMjolnir = true
    var firstFetchDone = false
    var currentPaginationInfo = InstagramPaginationInfo()
    var data: [InstagramMedia] = [InstagramMedia]() {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(InstagramNetworking.FetchedInstagramDataNotification, object: self)
        }
    }
    var userIsLoggedIn: Bool = true {
        willSet {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "MjolnirInstagramAPIAuthenticated")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            if newValue {
            NSNotificationCenter.defaultCenter().postNotificationName(InstagramNetworking.UserDidLogin, object: self)
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName(InstagramNetworking.UserDidLogout, object: self)
            }
        }
    }
    
    func fetchMedia() {
        
        if firstFetchDone {
            fetchPaginatedMedia()
        } else {
            let sharedEngine = InstagramEngine.sharedEngine()
            
            if let accessToken = NSUserDefaults.standardUserDefaults().objectForKey("MjolnirInstagramAccessToken") as? String {
                sharedEngine.accessToken = accessToken
            }
            
            if sharedEngine.accessToken != nil {
                if loadMjolnir {
                    getMediaForMjolnir()
                } else {
                    getMediaForHashtag()
                }
            } else {
                self.userIsLoggedIn = false
            }
        }
    }
    
    private func getMediaForMjolnir() {
        InstagramEngine.sharedEngine().getMediaForUser("324433330",
            count: 21,
            maxId: currentPaginationInfo.nextMaxId,
            withSuccess: { [unowned self] feed, paginationInfo in
                
                self.userIsLoggedIn = true
                self.data += feed as [InstagramMedia]
                
                if (paginationInfo != nil) {
                    self.currentPaginationInfo = paginationInfo
                    self.firstFetchDone = true
                } else {
                    self.reachedEndOfFeed = true
                }
            },
            failure: { error in
                
                //TODO: Display the error, only set false if user is not authenticated
                self.userIsLoggedIn = false
                NSNotificationCenter.defaultCenter().postNotificationName(InstagramNetworking.ErrorFetchingInstagramDataNotification, object: self, userInfo: ["Error" : error])
                
        })

    }
    
    private func getMediaForHashtag() {
        InstagramEngine.sharedEngine().getMediaWithTagName("mjolnirmma",
            count: 21,
            maxId: currentPaginationInfo.nextMaxId,
            withSuccess: { [unowned self] feed, paginationInfo in
                
                self.userIsLoggedIn = true
                self.data += feed as [InstagramMedia]
                
                if (paginationInfo != nil) {
                    self.currentPaginationInfo = paginationInfo
                    self.firstFetchDone = true
                } else {
                    self.reachedEndOfFeed = true
                }
            },
            failure: { error in
                
                //TODO: Display the error, only set false if user is not authenticated
                self.userIsLoggedIn = false
                NSNotificationCenter.defaultCenter().postNotificationName(InstagramNetworking.ErrorFetchingInstagramDataNotification, object: self, userInfo: ["Error" : error])
                
        })
    }
    
    private func fetchPaginatedMedia() {
        
        if  !reachedEndOfFeed {
            InstagramEngine.sharedEngine().getPaginatedItemsForInfo(currentPaginationInfo, withSuccess: {[unowned self] media, pagination in
                
                self.data += media as [InstagramMedia]
                if pagination != nil {
                    self.currentPaginationInfo = pagination
                } else {
                    self.reachedEndOfFeed = true
                }
                
                }, failure: {[unowned self] (error) -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(InstagramNetworking.ErrorFetchingInstagramDataNotification, object: self, userInfo: ["Error" : error])
            })
        }
    }

   
}
