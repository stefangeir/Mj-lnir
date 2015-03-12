//
//  TimetableDataModel.swift
//  Mjölnir
//
//  Created by Stefán Geir Sigfússon on 13.2.2015.
//  Copyright (c) 2015 Stefán Geir. All rights reserved.
//

import Foundation

class TimetableDataModel {
	
	struct singleClass {
		var name: String
	}
	
	let nogistelpur = singleClass(name: "Nogi stelpur")
	let nogi201 = singleClass(name: "Nogi 201")
	let nogi301 = singleClass(name: "Nogi 301")
	let mma101 = singleClass(name: "MMA 101")
	let mma101unglingar = singleClass(name: "MMA 101 Unglingar")
	let mma201 = singleClass(name: "MMA 201")
	let mma201unglingar = singleClass(name: "MMA 201 Unglingar")
	let mmact = singleClass(name: "MMA CT")
	let mjolnir101 = singleClass(name: "Mjölnir 101")
	let bjj301 = singleClass(name: "BJJ 301")
	let bjj201 = singleClass(name: "BJJ 201")
	let bjjct = singleClass(name: "BJJ CT")
	let bjjstelpur = singleClass(name: "BJJ stelpur")
	let openmat = singleClass(name: "Open Mat")
	let vikingathrek = singleClass(name: "Víkingaþrek")
    let extraIntenseVikingathrek = singleClass(name: "Erfiðara Víkingaþrek (90 mín)")
	let vikingathrek101 = singleClass(name: "Víkingaþrek 101")
	let vikingathrekunglingar = singleClass(name: "Víkingaþrek Unglingar")
	let box101 = singleClass(name: "Box 101")
	let box201 = singleClass(name: "Box 201")
	let box301 = singleClass(name: "Box 301")
	let sparr = singleClass(name: "Sparr")
	let kickbox101 = singleClass(name: "Kickbox 101")
	let kickbox201 = singleClass(name: "Kickbox 201")
	let kickbox301 = singleClass(name: "Kickbox 301")
	let born101 = singleClass(name: "Börn 101")
	let born201 = singleClass(name: "Börn 201")
	let yoga101 = singleClass(name: "Mjölnisyoga 101")
	let yoga201 = singleClass(name: "Mjölnisyoga 201")
	let godaafl = singleClass(name: "Goðaafl")
	
    func getAllClasses() -> [String] {
        var classes = [nogistelpur, nogi201, nogi301, mma101, mma101unglingar, mma201, mma201unglingar, mmact, mjolnir101, bjj301, bjj201,
        bjjct, bjjstelpur, openmat, vikingathrek, extraIntenseVikingathrek, vikingathrek101, vikingathrekunglingar, box101, box201, box301,
        sparr, kickbox101, kickbox201, kickbox301, born101, born201, yoga101, yoga201, godaafl]
        
        var strings = [String]()
        for single in classes {
            strings.append(single.name)
        }
        return strings
    }
    
    func getClassesForRoom(roomNumber: Int) -> [String:String] {
        var classes = [String:String]()
        return classes
    }
	
	func getClassesForWeekday(theWeekday: Int, theRoom: Int) -> [String:String]
	{
        var classes = [String:String]()
		
		if !(theWeekday < 1 || theWeekday > 7) {
			
			switch theRoom {
			case 1:
				switch theWeekday {
				case 1,3:
					classes = ["12:10": nogi201.name, "16:30": born201.name, "17:15":mma201unglingar.name, "18:00":bjj301.name, "19:00": bjj201.name, "20:00": kickbox201.name]
				case 2,4:
					classes = ["08:00":bjj201.name, "12:10":bjj201.name, "17:00":nogi301.name, "18:00":mmact.name, "20:00":mjolnir101.name]
				case 5:
					classes = ["12:10":nogi201.name, "16:30":born201.name, "17:15":mma201unglingar.name, "18:00":bjj201.name]
				case 6:
					classes = ["11:10":bjjct.name, "12:10":bjj201.name, "13:00":openmat.name]
				case 7:
					classes = ["12:10":openmat.name, "13:00":openmat.name]
				default:
					classes = ["error":"error"]
				}
			case 2:
				switch theWeekday{
				case 1:
					classes = ["06:40":vikingathrek.name, "12:10":vikingathrek.name, "16:30":vikingathrek.name, "17:15":vikingathrek.name, "18:00":box301.name, "19:00":kickbox301.name,  "20:00":vikingathrek.name]
				case 3:
					classes = ["06:40":vikingathrek.name, "12:10":vikingathrek.name, "16:30":vikingathrek.name, "17:15":vikingathrek.name, "18:00":box301.name, "19:00":mma201.name, "20:00":vikingathrek.name]
				case 2,4:
					classes = ["08:00":vikingathrek.name, "12:10":vikingathrek.name,"16:30":born101.name,"17:15":vikingathrek.name, "18:00":vikingathrek.name, "19:00":vikingathrek101.name, "20:00":kickbox101.name]
				case 5:
					classes = ["06:40":vikingathrek.name, "12:10":vikingathrek.name, "16:30":vikingathrek.name, "17:15":vikingathrek.name, "18:00":box201.name]
				case 6:
					classes = ["11:10":vikingathrek.name, "12:10":vikingathrek.name, "13:00":vikingathrekunglingar.name]
				case 7:
					classes = ["10:30":extraIntenseVikingathrek.name, "12:10":vikingathrek.name, "13:00":sparr.name]
				default:
					classes = ["error":"error"]
					
				}
			case 3:
				switch theWeekday{
				case 1:
					classes = ["12:10":yoga201.name, "17:15":godaafl.name, "18:00":mma101.name, "19:00":box201.name, "20:00":box101.name]
				case 2:
					classes = ["12:10":yoga101.name, "16:30":godaafl.name, "17:15":mma201unglingar.name, "18:00":mma101unglingar.name, "19:00":bjjstelpur.name, "20:00":nogi201.name]
				case 3:
					classes = ["12:10":mjolnir101.name, "17:15":godaafl.name, "18:00":kickbox301.name, "19:00":box201.name, "20:00":box101.name]
				case 4:
					classes = ["12:10":yoga101.name, "16:30":godaafl.name, "17:15":mma201unglingar.name, "18:00":mma101unglingar.name, "19:00":nogistelpur.name, "20:00":nogi201.name]
				case 5:
					classes = ["12:10":mjolnir101.name, "17:15":godaafl.name, "18:00":kickbox201.name]
				case 6:
					classes = ["11:10":yoga201.name, "13:10":yoga101.name]
				case 7:
					classes = ["13:10":yoga101.name]
				default:
					classes = ["error":"error"]
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

