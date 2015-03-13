//
//  instagramCVDatasource.swift
//  Mjölnir
//
//  Created by Stefán Geir on 23.2.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit



class InstagramCVDatasource: NSObject, UICollectionViewDataSource
{
    var mediaArray: [InstagramMedia] = [InstagramMedia]() {
        didSet {
            if self.controller != nil {
                self.controller!.collectionView?.reloadData()
            }
        }
    }
    var currentPaginationInfo = InstagramPaginationInfo()
    weak var controller: InstagramCVC?
    var loadMjolnir = true
    var firstFetchDone = false
    var userIsLoggedIn: Bool = true {
        willSet {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "MjolnirInstagramAPIAuthenticated")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.controller?.updateLoginButton()
            self.controller?.showYouMustLoginView(!newValue)
        }
    }
    var reachedEndOfFeed: Bool = false
    
    
    func fetchPaginatedMedia() {
        InstagramEngine.sharedEngine().getPaginatedItemsForInfo(currentPaginationInfo, withSuccess: { media, pagination in

            self.mediaArray += media as [InstagramMedia]
            if pagination != nil {
                self.currentPaginationInfo = pagination
            } else {
                self.reachedEndOfFeed = true
            }
            
        }) { (error) -> Void in

            let alertController = UIAlertController(title: "Error: ", message:
                error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Flott", style: UIAlertActionStyle.Default,handler: nil))
            
            self.controller!.presentViewController(alertController, animated: true, completion: nil)
            println("error í pagination")
        }
    }
    
    func loadMedia() {

        if firstFetchDone {
            fetchPaginatedMedia()
        } else {
            let sharedEngine = InstagramEngine.sharedEngine()
            
            if let accessToken = NSUserDefaults.standardUserDefaults().objectForKey("MjolnirInstagramAccessToken") as? String {
                sharedEngine.accessToken = accessToken
            }
            println("Reyni að sækja instagrammedia...")
           
            if sharedEngine.accessToken != nil {
                if loadMjolnir {
                    sharedEngine.getMediaForUser("324433330",
                        count: 21,
                        maxId: currentPaginationInfo.nextMaxId,
                        withSuccess: { feed, paginationInfo in

                            //TODO: Nota error codes og það úr instagramkit til að determina þetta drasl
                            self.userIsLoggedIn = true
                            self.mediaArray += feed as [InstagramMedia]
                            
                            println("sótti instagram media")
                            
                            if (paginationInfo != nil) {
                                self.currentPaginationInfo = paginationInfo
                                self.firstFetchDone = true
                            } else {
                                self.reachedEndOfFeed = true
                            }
                        },
                        failure: { error in

                            println("gat ekki sótt instagram media fyrir @mjolnirmma")
                            //TODO: Display the error, only set false if user is not authenticated
                            self.userIsLoggedIn = false
                            let alertController = UIAlertController(title: "Error: ", message:
                                error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                            
                            self.controller?.presentViewController(alertController, animated: true, completion: nil)
                            
                    })
                } else {
                    sharedEngine.getMediaWithTagName("mjolnirmma",
                        count: 21,
                        maxId: currentPaginationInfo.nextMaxId,
                        withSuccess: { feed, paginationInfo in
                            

                            self.userIsLoggedIn = true
                            
                            self.mediaArray += feed as [InstagramMedia]
                            
                            println("sótti instagram media fyrir #mjolnirmma")
                            
                            if (paginationInfo != nil) {
                                self.currentPaginationInfo = paginationInfo
                                self.firstFetchDone = true
                            } else {
                                self.reachedEndOfFeed = true
                            }
                        },
                        failure: { error in

                            println("gat ekki sótt instagram media fyrir @mjolnirmma")
                            //TODO: Display the error, only set false if user is not authenticated
                            self.userIsLoggedIn = false
                            let alertController = UIAlertController(title: "Error: ", message:
                                error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                            
                            self.controller?.presentViewController(alertController, animated: true, completion: nil)
                    })
                }
            } else {

               self.userIsLoggedIn = false
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !reachedEndOfFeed {
            return mediaArray.count + 1 // + 1 fyrir loading cellu
        } else {
            return mediaArray.count
        }
    }

    private struct Storyboard {
        static let InstagramImageCellReuseIdentifier = "reusable.instagramImageCell"
        static let LoadingCellReuseIdentifier = "reusable.instagramCVLoadingCell"
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.row < mediaArray.count {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.InstagramImageCellReuseIdentifier, forIndexPath: indexPath) as InstagramCVCell
            
            cell.media = mediaArray[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.LoadingCellReuseIdentifier, forIndexPath: indexPath) as InstagramCVLoadingCell
            
            cell.backgroundColor = UIColor.clearColor()
            cell.label.textColor = UIColor.whiteColor()
            
            if NSUserDefaults.standardUserDefaults().boolForKey("MjolnirInstagramAPIAuthenticated") {
                loadMedia()
            } else {
                userIsLoggedIn = false
                cell.label.text = ""
            }
            return cell
            
        }
    }
}
