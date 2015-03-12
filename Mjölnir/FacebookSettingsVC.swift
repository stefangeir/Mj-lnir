//
//  FacebookSettingsTVC.swift
//  Mjölnir
//
//  Created by Stefán Geir on 11.3.2015.
//  Copyright (c) 2015 Stefán Geir Sigfússon. All rights reserved.
//

import UIKit

class FacebookSettingsVC: UIViewController {

    @IBAction func changeSettings (sender: UISwitch) {
        if sender.on {
            openLinksInFacebookApp = true
        } else {
            openLinksInFacebookApp = false
        }
    }
    
    @IBOutlet weak var settingsSwitch: UISwitch!
    
    var openLinksInFacebookApp: Bool {
        get {
            if let value = NSUserDefaults.standardUserDefaults().objectForKey(openInFacebookAppUserDefaultsString) as? Bool {
                return value
            } else {
                NSUserDefaults.standardUserDefaults().setObject(false, forKey: openInFacebookAppUserDefaultsString)
                NSUserDefaults.standardUserDefaults().synchronize()
                return false
            }
        }
        
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: openInFacebookAppUserDefaultsString)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsSwitch.on = openLinksInFacebookApp
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.hidesBarsOnSwipe = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
}
