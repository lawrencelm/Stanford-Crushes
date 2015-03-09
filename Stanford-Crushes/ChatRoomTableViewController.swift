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
        println("update")
        tableView.reloadData()
    }
    
    // MARK: - Storyboard Connectivity
    
    
    private struct Storyboard {
        static let CellReuseIdentifier = "convo"
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var query = PFQuery(className: "AnonCrush")
        var array = query.findObjects()
        if array.count < 100 {
            return array.count
        } else {
            return 100
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as ChatRoomTableViewCell
        
        if indexPath.section == 0 {
            
        } else {
            
        }
        
        cell.row = indexPath.row
        
        return cell
    }
    
}
