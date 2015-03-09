//
//  ChatCollectionChat.swift
//  Stanford-Crushes
//
//  Created by Lawrence Lin Murata on 3/7/15.
//  Copyright (c) 2015 Lawrence Lin Murata. All rights reserved.
//

import UIKit

class ChatCell: UICollectionViewCell {
        
    var row: Int? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    var chat: AnyObject?
    
    var section: Int?
    
    func updateUI() {
    //figur eout what to do with the chat. maybe pass the chat object to perform the segue
    }
    
}
