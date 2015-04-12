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
    static let UserInfoKey = "Error"
}

class InstagramDataModel: NSObject
{
    var reachedEndOfFeed = false
    var loadMjolnir = true
    var firstFetchDone = false
    var currentPaginationInfo = InstagramPaginationInfo()
    var data: [InstagramMedia] = [InstagramMedia]()
    
    
    func reset() {
        reachedEndOfFeed = false
        firstFetchDone = false
        currentPaginationInfo = InstagramPaginationInfo()
        data.removeAll(keepCapacity: true)
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
        
        let sharedEngine = InstagramEngine.sharedEngine()
        
        // If sharedEngine containts no accesstoken from previous fetch we need one
        if sharedEngine.accessToken == nil {
            
            // Check weather one is stored in NSUserDefaults
            if let accessToken = NSUserDefaults.standardUserDefaults().objectForKey("MjolnirInstagramAccessToken") as? String {

                // Set it and fetch media
                sharedEngine.accessToken = accessToken
                if loadMjolnir {
                    getMediaForMjolnir()
                } else {
                    getMediaForHashtag()
                }
                
            } else {
                
                // If not, the user is not logged in
                self.userIsLoggedIn = false
            }
        } else {

            // sharedEngine contained accesstoken, fetch media
            if loadMjolnir {
                getMediaForMjolnir()
            } else {
                getMediaForHashtag()
            }
        }
    }
    
    private func getMediaForMjolnir() {
        InstagramEngine.sharedEngine().getMediaForUser("324433330",
            count: 21,
            maxId: currentPaginationInfo.nextMaxId,
            withSuccess: { [unowned self] feed, paginationInfo in
                
                self.data += feed as! [InstagramMedia]
                NSNotificationCenter.defaultCenter().postNotificationName(InstagramNetworking.FetchedInstagramDataNotification, object: self)
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
                NSNotificationCenter.defaultCenter().postNotificationName(InstagramNetworking.ErrorFetchingInstagramDataNotification, object: self, userInfo: [InstagramNetworking.UserInfoKey : error])
        })

    }
    
    private func getMediaForHashtag() {
        InstagramEngine.sharedEngine().getMediaWithTagName("mjolnirmma",
            count: 21,
            maxId: currentPaginationInfo.nextMaxId,
            withSuccess: { [unowned self] feed, paginationInfo in
                
                self.data += feed as! [InstagramMedia]
                NSNotificationCenter.defaultCenter().postNotificationName(InstagramNetworking.FetchedInstagramDataNotification, object: self)
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
                NSNotificationCenter.defaultCenter().postNotificationName(InstagramNetworking.ErrorFetchingInstagramDataNotification, object: self, userInfo: [InstagramNetworking.UserInfoKey : error])
                
        })
    }
}
