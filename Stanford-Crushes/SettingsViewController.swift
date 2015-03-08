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
    
    @IBOutlet weak var numBounciness: UILabel!
    
    @IBAction func changeBounciness(sender: UIStepper) {
        numBounciness.text = String(format:"%f", sender.value)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(sender.value, forKey: "bounciness")
    }
    
    @IBAction func changeAuth(sender: UISwitch) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(sender.selected, forKey: "auth")
    }
    
    @IBAction func changePush(sender: UIStepper) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(CGFloat(sender.value), forKey: "push")
    }
    
    @IBAction func changeTeam(sender: UISegmentedControl) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(sender.selectedSegmentIndex, forKey: "team")
    }
    
    @IBAction func changeRows(sender: UIStepper) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(sender.value, forKey: "numRows")
    }
    
    @IBAction func changeGravity(sender: UISwitch) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(sender.selected, forKey: "gravity")
        
    }
    
    
    
    
}