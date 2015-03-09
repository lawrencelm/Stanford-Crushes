//
//  ChatRoomTableViewController.swift
//  Stanford-Crushes
//
//  Created by Lawrence Lin Murata on 3/8/15.
//  Copyright (c) 2015 Lawrence Lin Murata. All rights reserved.
//

import UIKit
import Foundation
import HealthKit


class ChatRoomTableViewController: UITableViewController, UITextFieldDelegate {
    
   /* func testingHearRate() {
        if(isHealthDataAvailable()) {
            //do health stuff
           /* var health = HKHealthStore()
            var heartRate = HKQuantityTypeIdentifierHeartRate)*/
            let heartRateUnit: HKUnit = HKUnit.countUnit().unitDividedByUnit(HKUnit.minuteUnit())
            let heartRateQuantity: HKQuantity = HKQuantity(unit: heartRateUnit, doubleValue: height)
            
            var heartRate : HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
            
            println("heart rate is \(heartRate)")
            
            //let nowDate: NSDate = NSDate()
        }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("reloadTable"), userInfo: nil, repeats: true)
    }
    
    func reloadTable() {
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
    private var convoID: String?
    var type: String?

    
    
    func refresh() {
        //refresh information
    }
    
    
    private var sendMessage: String? {
        didSet {
            sendMessageField?.text = sendMessage
            tableView.reloadData() // clear out the table view
            sendMessageToPerson()
            println("did set string" + sendMessage!)
        }
    }
    
    @IBOutlet weak var sendMessageField: UITextField! {
        didSet {
            println("did set text field" + sendMessageField.text)
            sendMessageField.delegate = self
            sendMessageField.text = sendMessage
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == sendMessageField {
            textField.resignFirstResponder()
            sendMessage = textField.text
        }
        return true
    }
    
    func sendMessageToPerson() {
        println("sending message")
        //println(chat)
        //println(chatNum)
        
        if chat == nil {
            chat = []
        }
        
        var conversation = (chat as? NSArray) as Array?
        conversation!.append([PFUser.currentUser().username, sendMessage!])
        
        println(type)
        var query = PFQuery(className: type!)
        var object = query.getObjectWithId(convoID)
        println(convoID)
        println(object)
        object.setObject(conversation, forKey: "conversation")
        println(object)
        object.saveInBackgroundWithBlock { (success: Bool!, error: NSError!) -> Void in
            if success! {
                NSLog("Object updated")
            } else {
                NSLog("%@", error)
            }
        }
        
        /*var query = PFQuery(className: type!)
        var array = query.findObjects()
        println(chatNum)*/
        /*var index = array.count - 1 - chatNum!
        
        if index >= 0 {
            chat = array[index].objectForKey("conversation")
        } else {
            
        }*/
    }
    
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
            println("convo is \(chat)")

            convoID = array[index].objectId
            
            println("set convoID as \(convoID)")
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
        
        /*if indexPath.section == 0 {
            cell.type = "MatchChat"
        } else {
            cell.type = "AnonChat"
        }*/
        
        cell.type = type
        
        /*The code below first casts "chat" to an object of type NSArray (which conforms to the protocol AnyObject) and then to of type Array, which can be converted from it's Objective-C counterpart, NSArray.
        
        Note that this is a forced downcast. Only use this if you're sure that twData is going to be an instance of NSArray. Otherwise, use optionals:
        
        var conversation = (chat as? NSArray) as Array?*/
        
        var conversation = (chat as? NSArray) as Array?
        
        cell.conversation = conversation
        
      //  cell.contentView.backgroundColor = UIColor.clearColor()
        
       /* if conversation != nil {
            for message in conversation! {
                println("user is " + PFUser.currentUser().username)
                if message[0] as NSString == PFUser.currentUser().username {
                    cell.contentView.backgroundColor = UIColor(netHex: 0xF3726D)
                    println("theme color")
                } else {
                    cell.contentView.backgroundColor = UIColor.whiteColor()
                    println("white")
                }
                
            }
        }*/
        
       // println("type is")
       // println(type)
        
        //cell.type = type
        
        cell.row = indexPath.row
        
        return cell
    }
    
}
