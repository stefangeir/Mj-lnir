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

    weak var controller: FacebookTVC!
    var datamodel = FacebookDataModel()
    var fbPosts = [fbPost]()
    var indexOfNextPostToParse: Int = 0

    func refresh() {
        reset()
        datamodel.performRequest()
    }
    
    func reset() {
        datamodel.jsonDataArray.removeAll(keepCapacity: true)
        datamodel.paginationNext = nil
        datamodel.retryCount = 0
        fbPosts.removeAll(keepCapacity: true)
        indexOfNextPostToParse = 0
    }

    private struct Storyboard {
        static let PostCellIdentifier = "reusable.facebookCell"
        static let LoadingCellIdentifier = "reusable.facebookLoadingCell"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if controller.userIsLoggedIn {
            return fbPosts.count + 1 // + 1 fyrir loading cellið
        } else {
            return 0
        }
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
        
        if row < fbPosts.count {
            let postIDString = fbPosts[row].id!
            let stringArray = postIDString.componentsSeparatedByString("_")
            if stringArray.count == 2 {
                return "http://www.facebook.com/\(stringArray[0])/posts/\(stringArray[1])"
            }
            return "http://www.facebook.com/\(postIDString)"
        }
        return "http://www.facebook.com/"
        
    }
    
    func getItemTitleInRow(row: Int) -> String {
        return fbPosts[row].message!
    }
    
    func getIdInRow(row: Int) -> String {
        return fbPosts[row].id!
    }
    

    
    func parseData() {
        var i = Int()
        
        for i = indexOfNextPostToParse; i < datamodel.jsonDataArray.count; i++ {
            let post = datamodel.jsonDataArray[i]
            var messageString = post["message"].string
            
            if messageString == nil {
                messageString = post["story"].string
            }
            
            let thisPost = fbPost(link: post["link"].string,
                pictureUrl: post["picture"].string,
                message: messageString,
                date: post["created_time"].string,
                id: post["id"].string)
            
            fbPosts.append(thisPost)
        }
        
        indexOfNextPostToParse = i
        controller.refreshControl?.endRefreshing()
        controller.tableView.reloadData()
    }
    
    func handleFBError(note: NSNotification) {
        
        if let errorDict = note.userInfo as? [String:NSError] {
            let error = errorDict["Error"]
            
            let category = FBErrorUtility.errorCategoryForError(error)
            if category == FBErrorCategory.Permissions {
                controller.userIsLoggedIn = false
            } else if category == .Retry || category == .Throttling {
                if datamodel.retryCount < 3 {
                    datamodel.retryCount++
                    datamodel.performRequest()
                } else {
                    controller.showMessage("Gat ekki sótt gögn", withTitle: "Error")
                }
                
            } else if category == .AuthenticationReopenSession {
                controller.userIsLoggedIn = false
                controller.showMessage("Skráðu þig aftur inn", withTitle: "Logged out")
            } else {
                controller.showMessage("Reyndu aftur", withTitle: "Eitthvað vesen")
            }
        }
    }

    
}
