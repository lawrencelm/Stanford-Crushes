//
//  SettingsViewController.swift
//  Stanford-Crushes
//
//  Created by Lawrence Lin Murata on 3/4/15.
//  Copyright (c) 2015 Lawrence Lin Murata. All rights reserved.
//

import UIKit

//Lets you control the settings of certain variables.
//Is consistent between applcation launches because it uses NSUserDefaults

//extra credit: additional push setting
class SettingsViewController: UITableViewController {
    
    func logoutMessage() {
        let alert = UIAlertView()
        alert.title = "Successfully logged out!"
        //alert.message = "Enter correct e-mail/password"
        alert.addButtonWithTitle("OK")
        alert.show()
    }

    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        var currentUser = PFUser.currentUser()
        if currentUser == nil {
            logoutMessage()
        }
    }
    
    @IBAction func changeAuth(sender: UISwitch) {

        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(sender.selected, forKey: "auth")
    }
    
    @IBAction func setGender(sender: UISegmentedControl) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(sender.selectedSegmentIndex, forKey: "gender")
    }
    
    
}