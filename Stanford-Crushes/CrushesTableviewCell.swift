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
        println("upvote")
        var query = PFQuery(className: "AnonCrush")
        var array = query.findObjects()
        var index = array.count - 1 - row!
        if index >= 0 {
            println(index)
            var newNumber = array[index].objectForKey("upvotes") as Int?
            if newNumber != nil {
                println(newNumber)
                newNumber!++
                println(newNumber)
                array[index].setObject(newNumber, forKey: "upvotes")
                println(array[index].objectForKey("upvotes"))
                countLabel.text = String(newNumber!)
                array[index].saveInBackgroundWithBlock {
                    (success: Bool!, error: NSError!) -> Void in
                    if success! {
                        NSLog("Object created with id: \(array[index].objectId)")
                    } else {
                        NSLog("%@", error)
                    }
                }
            }
        }
        
    }
    
    func updateUI() {
        anonPost?.attributedText = nil
        countLabel?.attributedText = nil
        
        var query = PFQuery(className: "AnonCrush")
        var array = query.findObjects()
        var index = array.count - 1 - row!
        if index >= 0 {
            let newText: AnyObject? = array[index].objectForKey("post")
            let newNumber: AnyObject? = array[array.count - 1 - row!].objectForKey("upvotes")
            if newText != nil && newNumber != nil {
                anonPost.text = newText as? String
                countLabel.text = String(newNumber as Int)
            }
        }
        //println(index)
        //if index == 0 {
         //   sleep(1)
          //  println("time to reload")
          //  var table = CrushesTableViewController()
          //  table.reloadTable()
            //table.needReload = true
        //}
    }
}