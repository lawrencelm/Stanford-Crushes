//
//  ChatRoomCell.swift
//  Stanford-Crushes
//
//  Created by Lawrence Lin Murata on 3/8/15.
//  Copyright (c) 2015 Lawrence Lin Murata. All rights reserved.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {
    
    var row: Int? {
        didSet {
            update()
        }
    }
    
    var type: String?
    var conversation: Array<AnyObject>?
    
   // var playerChat = ChatRoomTableViewController()
    
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var username: UILabel!
    
    func update() {
        
        message?.attributedText = nil
        
        if conversation != nil {
            
            println("chat room type is \(type)")
            
            var index = conversation!.count - 1 - row!
            
            //downcasting to String. Thus, "as?"
            message.text = conversation![index][1] as? String
            if conversation![index][0] as NSString == PFUser.currentUser().username {
                self.contentView.backgroundColor = UIColor(netHex: 0xF3726D)
                println("theme color")
            } else {
                self.contentView.backgroundColor = UIColor.whiteColor()
                println("white")
            }
            
            if type == "MatchChat" {
                username.text = conversation![index][0] as NSString
            } else {
                username.text = ""
            }
            
        }
    }
    
    
    
}
