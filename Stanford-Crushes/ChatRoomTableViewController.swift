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
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var conversation = (chat as? NSArray) as Array?
        if conversation != nil {
            if conversation!.count < 100 {
                return conversation!.count
            } else {
                return 100
            }
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        println("CHATROOMTABLEVIEWCONTROLLER")
        
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
        
       // println("type is")
       // println(type)
        
        //cell.type = type
        
        cell.row = indexPath.row
        
        return cell
    }
    
}
