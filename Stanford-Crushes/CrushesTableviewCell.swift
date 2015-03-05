//
//  File.swift
//  Stanford-Crushes
//
//  Created by Lawrence Lin Murata on 3/2/15.
//  Copyright (c) 2015 Lawrence Lin Murata. All rights reserved.
//

import UIKit

class CrushesTableViewCell: UITableViewCell
{
    
    var row: Int? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var anonPost: UILabel!
    
    @IBAction func upvote(sender: AnyObject) {
        var query = PFQuery(className: "AnonCrush")
        var array = query.findObjects()
        var index = array.count - 1 - row!
        if index >= 0 {
            var newNumber = array[array.count - 1 - row!].objectForKey("upvotes") as Int?
            if newNumber != nil {
                newNumber!++
                array[array.count - 1 - row!].setObject(newNumber, forKey: "upvotes")
                countLabel.text = String(newNumber!)
            }
        }
    }
    
    @IBAction func downvote(sender: AnyObject) {
        var count = NSUserDefaults.standardUserDefaults().dictionaryRepresentation().count
        var index = count/2 - row!
        let defaults = NSUserDefaults.standardUserDefaults()
        let number = NSUserDefaults.standardUserDefaults().objectForKey(String(-index)) as Int?
        if number != nil {
            var numberN = number!
            numberN--
            println(numberN)
            countLabel.text = String(numberN)
            defaults.setInteger(numberN, forKey: String(-index))
        }
        
    }
    
    func updateUI() {
        anonPost?.attributedText = nil
        
        var query = PFQuery(className: "AnonCrush")
        var array = query.findObjects()
        var index = array.count - 1 - row!
        if index >= 0 {
            let newText: AnyObject? = array[array.count - 1 - row!].objectForKey("post")
            let newNumber: AnyObject? = array[array.count - 1 - row!].objectForKey("upvotes")
            if newText != nil && newNumber != nil {
                anonPost.text = newText as? String
                countLabel.text = String(newNumber as Int)
            }
        }
    }
}