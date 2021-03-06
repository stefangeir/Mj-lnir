//
//  MjolnirCVC.swift
//  MjolnirMisc
//
//  Created by Stefán Geir Sigfússon on 18.2.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import SwiftyJSON
import Alamofire
import UIKit


let formatter = NSDateFormatter()
let placeholderImageNameString = "placeholder"

struct WeekdaySelectSectionNumbers {
    static let businessDays: Int = 0
    static let weekendDays: Int = 1
    static let today = 2
}

class MainCVC: UICollectionViewController {
    let datasource = MainCVCDatasource()
    let delegate = MainCVCDelegate()
    var intToLongWeekdayNames = [Int:String]()
    var intToShortWeekdayNames = [Int:String]()
    let timetableSegueString: String = "segue.timetableForSelectedWeekday"
    let todayString: String = "í dag"
    
    func createWeekdays() -> (intToLongWeekdayDict:[Int:String], intToShortWeekdayDict:[Int:String], weekdays: [String]) {
        
        // Fáum weekdays
        var shortWeekdays = formatter.shortWeekdaySymbols as! [String]
        var longWeekdays = formatter.weekdaySymbols as! [String]
        // Byrjum vikuna á mánudegi
        longWeekdays.append(longWeekdays.first!)
        longWeekdays.removeAtIndex(0)
        shortWeekdays.append(shortWeekdays.first!)
        shortWeekdays.removeAtIndex(0)
        
        // Búum til dictionary sem bendir á dagana.. 1:mán, 2:þri...7:sun
        var intToLongWeekdayDict = [Int:String]()
        var intToShortWeekdayDict = [Int:String]()
        var ctr = 1
        for day in longWeekdays {
            intToLongWeekdayDict.updateValue(day, forKey: ctr++)
        }
        ctr = 1
        for day in shortWeekdays {
            intToShortWeekdayDict.updateValue(day, forKey: ctr++)
        }
        
        return (intToLongWeekdayDict, intToShortWeekdayDict, shortWeekdays)
    }
    
    let timetableURL = "https://raw.githubusercontent.com/trauzti/mjolnir-timetable/master/timetable.json"
    
    func downloadTimetable() {
        Alamofire.request(.GET, timetableURL).validate().responseJSON { [weak self] response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    TimetableDataModel.timetableResponse = JSON(value)
                }
            case .Failure(let error):
                let path = NSBundle.mainBundle().pathForResource("timetable", ofType: "json")
                let jsonData = NSData(contentsOfFile:path!)
                let json = JSON(data: jsonData!)
                TimetableDataModel.timetableResponse = json
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadTimetable()
        tabBarController?.tabBar.tintColor = UIColor.redColor()
        
        // Búum til intToWeekday dictionaryið og weekdays array
        var weekdays = [String]()
        (intToLongWeekdayNames, intToShortWeekdayNames, weekdays) = createWeekdays()
        
        var businessDays = [String]()
        for var i = 0; i < 5; i++ {
            businessDays.append(weekdays[i])
        }
        var weekendDays = [String]()
        for var i = 5; i < 7; i++ {
            weekendDays.append(weekdays[i])
        }
        var today = [todayString]
        datasource.buttons.updateValue(businessDays, forKey: WeekdaySelectSectionNumbers.businessDays)
        datasource.buttons.updateValue(weekendDays, forKey: WeekdaySelectSectionNumbers.weekendDays)
        datasource.buttons.updateValue(today, forKey: WeekdaySelectSectionNumbers.today)
        
        // Stillum default stærð fyrir takkana - þarf ekki því delegate implementar sizeforitematindexpath
        //        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
        //            layout.itemSize = CGSize(width: 100, height: 100)
        //        }
        
        delegate.controller = self
        collectionView?.dataSource = datasource
        collectionView?.delegate = delegate
        collectionView?.alwaysBounceVertical = true
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if segue.identifier == timetableSegueString,
			let cell = sender as? MainCVCell,
			let indexPath = collectionView?.indexPathForCell(cell),
			let timetable = segue.destinationViewController as? TimetableClassesTVC {
				switch cell.buttonLabel.text! {
				case todayString:
					formatter.dateFormat = "EEE"
					let todayDate = NSDate()
					let todayString = formatter.stringFromDate(todayDate)
					var todayWeekdayInt: Int?
					
					for (key, daystring) in intToShortWeekdayNames {
						
						if todayString == daystring {
							todayWeekdayInt = key
						}
					}
					
					timetable.selectedWeekday = todayWeekdayInt!
					timetable.title = intToLongWeekdayNames[timetable.selectedWeekday!]
				default:
					
					for (key, daystring) in intToShortWeekdayNames {
						
						if cell.buttonLabel.text! == daystring {
							timetable.selectedWeekday = key
						}
					}
					timetable.title = intToLongWeekdayNames[timetable.selectedWeekday!]
				}
		}
	}
}
