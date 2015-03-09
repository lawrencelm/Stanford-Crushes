//
//  ChatRoomTableViewController.swift
//  Stanford-Crushes
//
//  Created by Lawrence Lin Murata on 3/8/15.
//  Copyright (c) 2015 Lawrence Lin Murata. All rights reserved.
//

import UIKit
import Foundation


class ChatRoomTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("reloadTable"), userInfo: nil, repeats: true)
    }
    
    func reloadTable() {
       // println("update")
        tableView.reloadData()
    }
    
    var needReload : Bool? {
        didSet {
            tableView.reloadData() // clear out the table view
            refresh()
        }
    }
    
    var chat: AnyObject?
    var chatNum : Int?
    var chatSize: Int?
    
    func refresh() {
        //refresh information
    }
    
    var type: String?
    
    // MARK: - Storyboard Connectivity
    
    
    private struct Storyboard {
        static let CellReuseIdentifier = "convo"
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        println("sections")
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("rows")
        println(type)
        var query = PFQuery(className: type!)
        var array = query.findObjects()
        println(chatNum)
        var index = array.count - 1 - chatNum!
        //println(array)
        
        if index >= 0 {
            chat = array[index].objectForKey("conversation")
           // println(array[index].objectForKey("conversation"))
        } else {
            return 0
        }
      //  var conversation = (array[index] as? NSArray) as Array?
      //  println(conversation)
        
        var conversation: AnyObject? = array[index].objectForKey("conversation")
        //conversation?.count
        if conversation != nil {
            if conversation?.count < 100 {
                return (conversation?.count)!
            } else {
                return 100
            }
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //println("CHATROOMTABLEVIEWCONTROLLER")
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as ChatRoomTableViewCell
        
        if indexPath.section == 0 {
            cell.type = "MatchChat"
        } else {
            cell.type = "AnonChat"
        }
        
        /*The code below first casts "chat" to an object of type NSArray (which conforms to the protocol AnyObject) and then to of type Array, which can be converted from it's Objective-C counterpart, NSArray.
        
        Note that this is a forced downcast. Only use this if you're sure that twData is going to be an instance of NSArray. Otherwise, use optionals:
        
        var conversation = (chat as? NSArray) as Array?*/
        
        var conversation = (chat as? NSArray) as Array?
        
        cell.conversation = conversation
        
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        if conversation != nil {
            for message in conversation! {
                println("user is " + PFUser.currentUser().username)
                if message[0] as NSString == PFUser.currentUser().username {
                    cell.backgroundColor = UIColor(netHex: 0xF3726D)
                    println("theme color")
                } else {
                    cell.backgroundColor = UIColor.whiteColor()
                    println("white")
                }
                
            }
        }
        
       // println("type is")
       // println(type)
        
        //cell.type = type
        
        cell.row = indexPath.row
        
        return cell
    }
    
}
