//
//  TimetableClassesDatasource.swift
//  Mjölnir
//
//  Created by Stefán Geir Sigfússon on 16.2.2015.
//  Copyright (c) 2015 Stefán Geir. All rights reserved.
//

import UIKit

class TimetableClassesDatasource: NSObject, UITableViewDataSource
{
	
    let data = TimetableDataModel()
    weak var controller: TimetableClassesTVC?
    
    var selectedWeekday: Int?
    private var classesForRoom = [Int:[String:String]]()
    private var timesForRoom = [Int:[String]]()
	
	
	
	func updateModel() {
        classesForRoom = [1:data.getClassesForWeekday(selectedWeekday!, theRoom: 1),
            2: data.getClassesForWeekday(selectedWeekday!, theRoom: 2),
            3: data.getClassesForWeekday(selectedWeekday!, theRoom: 3)]
        
        timesForRoom = [1:[String](classesForRoom[1]!.keys).sorted(<),
            2:[String](classesForRoom[2]!.keys).sorted(<),
            3:[String](classesForRoom[3]!.keys).sorted(<)]
        
        controller!.tableView.reloadData()
	}
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return timetableSectionTitles.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return timetableSectionTitles[section]
    }
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
        let roomNumber = section + 1
        if timesForRoom[roomNumber] != nil {
            return timesForRoom[roomNumber]!.count
        }
        return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier(timetableReusableCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        let roomNumber = indexPath.section + 1
        let classNumber = indexPath.row
        
        if let timeString = timesForRoom[roomNumber]?[classNumber] {
            cell.textLabel?.text = timeString
            cell.detailTextLabel?.text = classesForRoom[roomNumber]?[timeString]
//            cell.textLabel?.textColor = UIColor.whiteColor()
//            cell.detailTextLabel?.textColor = UIColor.whiteColor()
//            cell.backgroundColor = UIColor.clearColor()
        }
		return cell
}
	
	
}
