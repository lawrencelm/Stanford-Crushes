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
    
    @IBOutlet weak var message: UILabel!
    
    func update() {
        message?.attributedText = nil
        
        var query = PFQuery(className: "AnonCrush")
        var array = query.findObjects()
        var index = array.count - 1 - row!
        if index >= 0 {
            let newText: AnyObject? = array[index].objectForKey("post")
            let newNumber: AnyObject? = array[array.count - 1 - row!].objectForKey("upvotes")
            if newText != nil && newNumber != nil {
               // anonPost.text = newText as? String
            }
        }
    }
    
}
