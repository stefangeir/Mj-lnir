//
//  SelectWeekdayTVC.swift
//  Mjölnir
//
//  Created by Stefán Geir on 10.3.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit

//let formatter = NSDateFormatter()
//let backgroundImageString = "background"
//let buttonTouchedNotificationNameString: String = "selectedButtonInMainView"
//let newsSegueString: String = "segue.news"
//let timetableSegueString: String = "segue.timetable"
//let instagramButtonString: String = "@mjolnirmma"
//let instagramSegueString: String = "segue.instagram"
//let newsButtonString: String = "Fréttir"
//let todayString: String = "í dag"
//let instagramHashtagButtonString: String = "#mjolnirmma"
//let facebookButtonString: String =  "Facebook"
//let facebookSegueString: String = "segue.facebook"
//let placeholderImageNameString = "placeholder"

class SelectWeekdayTVC: UITableViewController {

    let reuseIdentifier = "reusable.selectWeekdayCell"
    var intToLongWeekdayNames = [Int:String]()
    
    func createWeekdays() -> (intToLongWeekdayDict:[Int:String], weekdays: [String]) {
        
        // Fáum weekdays
        var longWeekdays = formatter.weekdaySymbols as [String]
        // Byrjum vikuna á mánudegi
        longWeekdays.append(longWeekdays.first!)
        longWeekdays.removeAtIndex(0)
        // Búum til dictionary sem bendir á dagana.. 1:mán, 2:þri...7:sun
        var intToLongWeekdayDict = [Int:String]()
        var ctr = 1
        for day in longWeekdays {
            intToLongWeekdayDict.updateValue(day, forKey: ctr++)
        }
        
        return (intToLongWeekdayDict, longWeekdays)
    }
    
    var cellText = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var weekdays = [String]()
        (intToLongWeekdayNames, weekdays) = createWeekdays()
        cellText = ["í dag"] + weekdays
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.tableFooterView?.hidden = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellText.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = cellText[indexPath.row]
        return cell
    }

      // MARK: - Navigation


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == timetableSegueString {
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPathForCell(cell) {
                    if let timetable = segue.destinationViewController as? TimetableClassesTVC {
                        if let cellsText = cell.textLabel?.text {
                            switch cellsText {
                            case todayString:
                                formatter.dateFormat = "EEEE"
                                let todayDate = NSDate()
                                let todayString = formatter.stringFromDate(todayDate)
                                var todayWeekdayInt: Int?
                                
                                for (key, daystring) in intToLongWeekdayNames {
                                    if todayString == daystring {
                                        todayWeekdayInt = key
                                    }
                                }
                                
                                timetable.selectedWeekday = todayWeekdayInt!
                                timetable.title = intToLongWeekdayNames[timetable.selectedWeekday!]
                            default:
                                timetable.selectedWeekday = indexPath.row
                                timetable.title = intToLongWeekdayNames[timetable.selectedWeekday!]
                            }
                        }
                    }
                }
                
            }
        }
    }

}
