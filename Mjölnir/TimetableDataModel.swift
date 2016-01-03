//
//  TimetableDataModel.swift
//  Mjölnir
//
//  Created by Stefán Geir Sigfússon on 13.2.2015.
//  Copyright (c) 2015 Stefán Geir. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON


class TimetableDataModel {
    
    static var timetableResponse: JSON!
    
    var initialized = false
    
    init() {
        if (TimetableDataModel.timetableResponse != nil ) {
            initClasses() // need to call this when the timetable has been updated
        }
    }
	
    
    var classStrings = [String]()
    
    func initClasses() {
        if (initialized) {
            return
        }
        let ttResp = TimetableDataModel.timetableResponse
        if classStrings.count == 0 && ttResp != nil {
            
            var times: [JSON] = []
            for timeEntry in ttResp["mon"] {
                times.append(timeEntry.1)
            }
            
            for timeEntry in ttResp["tue"] {
                times.append(timeEntry.1)
            }
            for timeEntry in ttResp["wed"] {
                times.append(timeEntry.1)
            }
            for timeEntry in ttResp["thu"] {
                times.append(timeEntry.1)
            }
            for timeEntry in ttResp["fri"] {
                times.append(timeEntry.1)
            }
            for timeEntry in ttResp["sat"] {
                times.append(timeEntry.1)
            }
            for timeEntry in ttResp["sun"] {
                times.append(timeEntry.1)
            }
            
            var seenClasses = [String:Bool]()
            for t in times {
                let title = t["title"].stringValue
                if seenClasses[title] == nil {
                    classStrings.append(title)
                    seenClasses[title] = true
                }
            }
            
        }
        initialized = true
    }
	
    func getAllClasses() -> [String] {
        return classStrings
    }
    
    // room, time, title
    func getMjolnirClassValues(jsonItem: JSON) -> (Int, String, String) {
        let roomString = jsonItem["room"].stringValue
        let roomArr = roomString.characters.split{$0 == " "}.map(String.init)
        let room: Int = Int(roomArr[1])!
        let time = jsonItem["time"].stringValue
        let title = jsonItem["title"].stringValue
        return (room, time, title)
    }

	
	func getClassesForWeekday(theWeekday: Int, inRoom: Int) -> [String:String]
	{
        let ttResp:JSON = TimetableDataModel.timetableResponse
        var classes = [String:String]()
        if (ttResp != nil) {
            initClasses()
            switch theWeekday {
            case 1:
                for cl in ttResp["mon"].arrayValue {
                    let (room, time, title) = getMjolnirClassValues(cl)
                    if inRoom == room {
                        classes[time] = title
                    }
                }
            case 2:
                for cl in ttResp["tue"].arrayValue {
                    let (room, time, title) = getMjolnirClassValues(cl)
                    if inRoom == room {
                        classes[time] = title
                    }
                }
            case 3:
                for cl in ttResp["wed"].arrayValue {
                    let (room, time, title) = getMjolnirClassValues(cl)
                    if inRoom == room {
                        classes[time] = title
                    }
                }
            case 4:
                for cl in ttResp["thu"].arrayValue {
                    let (room, time, title) = getMjolnirClassValues(cl)
                    if inRoom == room {
                        classes[time] = title
                    }
                }
            case 5:
                for cl in ttResp["fri"].arrayValue {
                    let (room, time, title) = getMjolnirClassValues(cl)
                    if inRoom == room {
                        classes[time] = title
                    }
                }
            case 6:
                for cl in ttResp["sat"].arrayValue {
                    let (room, time, title) = getMjolnirClassValues(cl)
                    if inRoom == room {
                        classes[time] = title
                    }
                }
            case 7:
                for cl in ttResp["sun"].arrayValue {
                    let (room, time, title) = getMjolnirClassValues(cl)
                    if inRoom == room {
                        classes[time] = title
                    }
                }
            default:
                break
            }
        }
    
        
        var removeTheseClasses = [String]()
        
        if let shownClassesDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(keyForShownClassesDictionaryString) as? [String:Bool] {
            
            for (startTime, singleClass) in classes {
                if let shown = shownClassesDictionary[singleClass] {
                    if !shown {
                        removeTheseClasses.append(startTime)
                    }
                }
            }
            
            for startTime in removeTheseClasses {
                classes.removeValueForKey(startTime)
            }
            
        }
        return classes
    }
}

