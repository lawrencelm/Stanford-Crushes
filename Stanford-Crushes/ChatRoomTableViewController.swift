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
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    func update() {
        println("update")
    }
}
