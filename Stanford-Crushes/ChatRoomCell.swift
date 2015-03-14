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
    
    @IBOutlet weak var username: UILabel!
    
    func update() {
        
        message?.attributedText = nil
        
        if conversation != nil {
            
            println("chat room type is \(type)")
            
            var index = conversation!.count - 1 - row!
            
            //downcasting to String. Thus, "as?"
            var newMessage = conversation![index][1] as? String
            
            
            
            if newMessage?.rangeOfString("#hb") != nil {
                // It's an encoded heart beat
                //it encodes your heart beat into a mesage that is stored
                //in our database. then decoded when we read the message
                
                println("found encoded heart beat \(newMessage)")
                var changeNewMessage = ""
                var stringNumberBeat = ""
                
                var i = 0
                
                for ch in newMessage! {
                    println("character \(ch) at index \(i)")
                    if i >= 3 {
                        stringNumberBeat = stringNumberBeat + String(ch)
                    }
                    
                    i++
                }
                
                println("string number beat \(stringNumberBeat)")
                var valueBeat = stringNumberBeat.toInt()
                println("valueBeat is \(valueBeat)")
                
                for var i = 0; i < valueBeat; i++ {
                    
                    // Heart pic is intensified according to how fast
                    // your heart is beating
                    changeNewMessage = changeNewMessage + "♥️"
                }
                newMessage = changeNewMessage
            }
            
            message.text = newMessage
            
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
