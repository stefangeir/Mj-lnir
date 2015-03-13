//
//  TimetableClassesTVCTableViewController.swift
//  Mjölnir
//
//  Created by Stefán Geir Sigfússon on 12.2.2015.
//  Copyright (c) 2015 Stefán Geir. All rights reserved.
//

import UIKit

let timetableReusableCellIdentifier = "reusable.timetableClassCell"
let timetableSectionTitles = ["Salur 1", "Salur 2", "Salur 3"]
class TimetableClassesTVC: UITableViewController {
	
    let shownClassesSegueString = "segue.shownClasses"
    var selectedWeekday: Int?
	let datasource = TimetableClassesDatasource()
	let delegate = TimetableClassesDelegate()
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Setjum weekday og sækjum gögn
        datasource.selectedWeekday = selectedWeekday!
        datasource.controller = self
		tableView.dataSource = datasource
		tableView.delegate = delegate
        datasource.updateModel()
	}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //datasource.updateModel()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == shownClassesSegueString {
            if let navVC = segue.destinationViewController as? UINavigationController {
                if let shownClasses = navVC.viewControllers.first as? ShownClassesTVC {
                    shownClasses.timetableDatasource = datasource
                }
            }
        }
    }
    
    @IBAction func changedShownClasses(segue: UIStoryboardSegue) {
        datasource.updateModel()
    }
    
}
