//
//  facebookTVDatasource.swift
//  Mjölnir
//
//  Created by Stefán Geir on 21.2.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit


struct fbPost {
    var link: String?
    var pictureUrl: String?
    var message: String?
    var date: String?
    var id: String?
}

class FacebookTVDatasource: NSObject, UITableViewDataSource
{
    var posts = [JSON]()
    var paginationNext: String?
    weak var controller: FacebookTVC?
    var retryCount = 0
    
    func reset() {
        posts.removeAll(keepCapacity: true)
        fbPosts.removeAll(keepCapacity: true)
        paginationNext = nil
        indexOfNextPostToParse = 0
    }
    
    func getData() {
        println("Reyni að sækja facebook gögn..")
        var requestPath = String()
        
        if paginationNext == nil {
            reset()
            requestPath = "Mjolnir.MMAclub?fields=posts.limit(10)"
        } else {
            requestPath = paginationNext!
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        FBRequestConnection.startWithGraphPath(requestPath,
            parameters: nil,
            HTTPMethod: "GET",
            completionHandler:{ response, data, error in
                println("Sótti facebook gögn")
                if error == nil {
                    self.retryCount = 0
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        let jsonData = JSON(data)
                        
                        if let posts = jsonData["posts"]["data"].array {
                            self.posts += posts
                            self.parseData()
                        } else if let posts = jsonData["data"].array {
                            self.posts += posts
                            self.parseData()
                        }
                        if let paginationPath = jsonData["posts"]["paging"]["next"].string {
                            let delimeter = "https://graph.facebook.com/v2.2/"
                            self.paginationNext = paginationPath.componentsSeparatedByString(delimeter).last
                        } else if let paginationPath = jsonData["paging"]["next"].string {
                            let delimeter = "https://graph.facebook.com/v2.2/"
                            self.paginationNext = paginationPath.componentsSeparatedByString(delimeter).last
                        }

                    
                } else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.controller?.refreshControl?.endRefreshing()
                    self.handleFBError(error)
                }
        })
    }
    
    func handleFBError(error: NSError) {
       
        if FBErrorUtility.errorCategoryForError(error) == FBErrorCategory.Permissions {
            controller?.userIsLoggedIn = false
        } else if FBErrorUtility.errorCategoryForError(error) == FBErrorCategory.Retry || FBErrorUtility.errorCategoryForError(error) == FBErrorCategory.Throttling {
            if retryCount < 3 {
                retryCount++
                getData()
            } else {
                controller?.showMessage("Gat ekki sótt gögn", withTitle: "Error")
            }
            
        } else {
            controller?.showMessage("Reyndu aftur", withTitle: "Eitthvað vesen")
        }
    }
    
    
    
    var fbPosts = [fbPost]()
    var indexOfNextPostToParse: Int = 0
    
    func parseData() {
        var i = Int()
        
        for i = indexOfNextPostToParse; i < posts.count; i++ {
            let post = posts[i]
            var messageString = post["message"].string
            
            if let message = messageString {
                messageString = message
                
            } else {
                messageString = post["story"].string
            }
            var thisPost = fbPost(link: post["link"].string,
                pictureUrl: post["picture"].string,
                message: messageString,
                date: post["created_time"].string,
                id: post["id"].string)
            
            fbPosts.append(thisPost)
        }
        
        indexOfNextPostToParse = i

        
        controller?.refreshControl?.endRefreshing()
        controller?.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if controller!.userIsLoggedIn {
            return fbPosts.count + 1 // + 1 fyrir loading cellið
        } else {
            return 0
        }
    }
    
    private struct Storyboard {
        static let PostCellIdentifier = "reusable.facebookCell"
        static let LoadingCellIdentifier = "reusable.facebookLoadingCell"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        if indexPath.row < fbPosts.count {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.PostCellIdentifier, forIndexPath: indexPath) as FacebookPostTVCell
            cell.post = fbPosts[indexPath.row]
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.LoadingCellIdentifier) as FacebookLoadingTVCell
            
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
            cell.backgroundColor = UIColor.blackColor()
            return cell
        }
    }
    
    func getItemLinkInRow(row: Int) -> String {
        
        let string = fbPosts[row].id!
        let stringArray = string.componentsSeparatedByString("_")
        if stringArray.count == 2 {
            return "http://www.facebook.com/" + stringArray[0] + "/posts/" + stringArray[1]
        }
        
        return "http://www.facebook.com/" + string
        
    }
    func getItemTitleInRow(row: Int) -> String {
        return fbPosts[row].message!
    }
    func getIdInRow(row: Int) -> String {
        return fbPosts[row].id!
    }
    
}
