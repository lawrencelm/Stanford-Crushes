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
        
        /*message?.attributedText = nil
        
        println(conversation!.count)
        
        println(conversation!)*/
        
        message?.attributedText = nil
        
       // println("UPDATEXYZ")
        
        if conversation != nil {
            
            var index = conversation!.count - 1 - row!
            
            //downcasting to String. Thus, "as?"
           // if (conversation![index] != nil) {// && (conversation![index].count == 2 {
                message.text = conversation![index][1] as? String
           // }
        }
        
       // if type != nil {
        
        //var query = PFQuery(className: type)
        //var array = query.findObjects()
        //var index = array.count - 1 - row!
            
        //if index >= 0 {
           // let chatLog: AnyObject? = array[index].objectForKey("conversation")
     //       println(conversation)
            
            
            
            //let newNumber: AnyObject? = array[array.count - 1 - row!].objectForKey("upvotes")
          /*  if chatLog != nil {// && newNumber != nil {
               // anonPost.text = newText as? String
                println(chatLog)
                let conversation = (chatLog as? NSArray) as Array?
                if conversation != nil {
                for message in conversation! {
                    
                }
                }
            }*/
       // }
        //}
    }
    
}
