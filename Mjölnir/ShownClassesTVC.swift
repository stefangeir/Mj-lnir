//
//  ShownClassesTVC.swift
//  Mjölnir
//
//  Created by Stefán Geir on 3.3.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit
let keyForShownClassesDictionaryString = "MjolnirShownClasses"

class ShownClassesTVC: UITableViewController {

    let shownClassesCellIdentifier = "reusable.shownClasses"
    let unwindSegueString = "segue.updatedShownClasses"
    weak var timetableDatasource: TimetableClassesDatasource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        title = "Velja sýnda tíma"
        allClasses = model.getAllClasses()
        allClasses.sortInPlace(<)
        
        if let dict = NSUserDefaults.standardUserDefaults().dictionaryForKey(keyForShownClassesDictionaryString) as? [String:Bool] {
            updatedShownClasses = dict
        } else {
            var dict = [String:Bool]()
            for singleClass in allClasses {
                dict.updateValue(true, forKey: singleClass)
            }
            updatedShownClasses = dict
        }
    }

    // MARK: - Table view data source

    var updatedShownClasses = [String:Bool]?()
    var model = TimetableDataModel()
    var allClasses = [String]()
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allClasses.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(shownClassesCellIdentifier, forIndexPath: indexPath) as! UITableViewCell

        var className = allClasses[indexPath.row]
        if let dict = updatedShownClasses {
            if let shown = dict[className] {
                if shown {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            }
        
        } else {
            cell.textLabel?.text = "Villa við að sækja stillingar"
        }
        cell.textLabel?.text = className
        cell.backgroundColor = UIColor.blackColor()
            
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if let classname = cell.textLabel?.text {
                if cell.accessoryType == .Checkmark {
                    cell.accessoryType = .None
                    updatedShownClasses!.updateValue(false, forKey: classname)

                } else if cell.accessoryType == .None {
                    cell.accessoryType = .Checkmark
                    updatedShownClasses!.updateValue(true, forKey: classname)
                }
            }
        }
    }
    
    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == unwindSegueString {
            if let updatedShownClasses = updatedShownClasses {
                NSUserDefaults.standardUserDefaults().setObject(updatedShownClasses, forKey: keyForShownClassesDictionaryString)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }


}
