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
import AVFoundation


class ChatRoomTableViewController: UITableViewController, UITextFieldDelegate {
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        if let mtvc = destination as? ChatViewController {
            println("segue back")
            if player != nil {
                player.pause()
            }
        }
    }*/
    
    override func viewWillDisappear(animated: Bool) {
        // back button was pressed. 
        if player != nil {
            player.pause()
        }
    }
    
    var healthStore = HKHealthStore()
    let myHeight: Double = 1.7
    
    func getHearRate() {
        if(HKHealthStore.isHealthDataAvailable()) {
            //do health stuff
            /* var health = HKHealthStore()
            var heartRate = HKQuantityTypeIdentifierHeartRate)*/
            let height = myHeight
            let heartRateUnit: HKUnit = HKUnit.countUnit().unitDividedByUnit(HKUnit.minuteUnit())
            let heartRateQuantity: HKQuantity = HKQuantity(unit: heartRateUnit, doubleValue: height)
            
            var heartRate : HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
            
            println("heart rate is \(heartRate.aggregationStyle.hashValue)")
            println("heart rate is \(heartRate.aggregationStyle.rawValue)")
            
        }
    }
    
    var player : AVAudioPlayer! = nil
    var firstTime: Bool = true
    let songType: String = "mp3"
    let songName: String = "theme"
    let numSongs: Int = 4
    
    @IBAction func shareMusicNow(sender: AnyObject) {
        println("shareMusicNow")
        var query = PFQuery(className: type!)
        var object = query.getObjectWithId(convoID)
        println(convoID)
        println(object)
        object.setObject(true, forKey: "play")
        println(object)
        object.saveInBackgroundWithBlock { (success: Bool!, error: NSError!) -> Void in
            if success! {
                NSLog("Object updated")
            } else {
                NSLog("%@", error)
            }
        }
        
        if firstTime {
            playRandom()
        }
    }
    
    func stopSharingMusic() {
        var query = PFQuery(className: type!)
        var object = query.getObjectWithId(convoID)
        println(convoID)
        println(object)
        object.setObject(false, forKey: "play")
        println(object)
        object.saveInBackgroundWithBlock { (success: Bool!, error: NSError!) -> Void in
            if success! {
                NSLog("Object updated")
            } else {
                NSLog("%@", error)
            }
        }
        
        if firstTime {
            playRandom()
        }
    }
    
    func checkPlay() -> Bool {
        println("checkPlay")
        var query = PFQuery(className: type!)
        var array = query.findObjects()
        println("chat num is \(chatNum). array count is \(array.count). type is \(type!). array is \(array)")
        var index = array.count - 1 - chatNum!
        println("index is \(index)")
        
        if index >= 0 {
            var playOrNot: Bool? = array[index].objectForKey("play") as? Bool
            
            if playOrNot != nil {
                println("returning \(playOrNot!)")
                return playOrNot!
            } else {
                println("returning false")
                return false
            }
        }
        println("index out of bounds")
        return false
    }
    
    func playRandom() {
        var randomNum : Int = Int(CGFloat.random(numSongs))
        
        //only need this if your first song starts at 1
        /*if randomNum == 0 {
        randomNum++
        }*/
        
        var song: String = songName + String(randomNum)
        playMusic(song)
    }
    
    func playMusic(song: String) {
        let path = NSBundle.mainBundle().pathForResource(song, ofType: songType)
        let fileURL = NSURL(fileURLWithPath: path!)
        player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        player.prepareToPlay()
        player.play()
    }
    
    private func saveHeartRateIntoHealthStore(height:Double) -> Void
    {
        if(HKHealthStore.isHealthDataAvailable()) {
            
            // Save the user's heart rate into HealthKit.
            let heartRateUnit: HKUnit = HKUnit.countUnit().unitDividedByUnit(HKUnit.minuteUnit())
            let heartRateQuantity: HKQuantity = HKQuantity(unit: heartRateUnit, doubleValue: height)
            
            var heartRate : HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
            let nowDate: NSDate = NSDate()
            
            let heartRateSample: HKQuantitySample = HKQuantitySample(type: heartRate
                , quantity: heartRateQuantity, startDate: nowDate, endDate: nowDate)
            
            let completion: ((Bool, NSError!) -> Void) = {
                (success, error) -> Void in
                
                if !success {
                    println("An error occured saving the Heart Rate sample \(heartRateSample). The error was: \(error).")
                    
                    abort()
                } else {
                    println("Successfully saved the Heart Rate sample \(heartRateSample).")
                }
                
            }
            /* When your app ID is authorized for HealthKit, you should comment the next line of code out
            Right now, if you leave this commented out, all you get from the getHearRate() function
            is the default value of the Heart Rate.
            
            Measuring your heart rate requires third-party applications, usually via Bluetooth,
            that you can use together with this app to store actual heart rate values. The goal of
            this app is not to be a medical app, but to take advantage of the heart rate data in order
            to send this heart rate value (in an encoded format that is embedded in messages)
            to your beloved/person you are talking to. */
            
            //self.healthStore.saveObject(heartRateSample, withCompletion: completion)
        }
    } // end saveHeartRateIntoHealthStore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveHeartRateIntoHealthStore(myHeight)
        getHearRate()
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("reloadTable"), userInfo: nil, repeats: true)
       // if player != nil {
        if (firstTime && checkPlay()) {
            firstTime = false
            playRandom()
        }
        //}
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
    }
    
    // MARK: - Storyboard Connectivity
    
    
    private struct Storyboard {
        static let CellReuseIdentifier = "convo"
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        println("sections")
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("rows")
        if section == 1 {
        println(type)
        var query = PFQuery(className: type!)
        var array = query.findObjects()
        println(chatNum)
        var index = array.count - 1 - chatNum!
        
        if index >= 0 {
            chat = array[index].objectForKey("conversation")
            println("convo is \(chat)")
            
            convoID = array[index].objectId
            
            println("set convoID as \(convoID)")
        } else {
            return 0
        }
        
        var conversation: AnyObject? = array[index].objectForKey("conversation")
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
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.section == 1 {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as ChatRoomTableViewCell
        
        cell.type = type
        
        /*The code below first casts "chat" to an object of type NSArray (which conforms to the protocol AnyObject) and then to of type Array, which can be converted from it's Objective-C counterpart, NSArray.
        
        Note that this is a forced downcast. Only use this if you're sure that twData is going to be an instance of NSArray. Otherwise, use optionals:
        
        var conversation = (chat as? NSArray) as Array?*/
        
        var conversation = (chat as? NSArray) as Array?
        
        cell.conversation = conversation
        
        
        
        cell.row = indexPath.row
        
        return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("options", forIndexPath: indexPath) as UITableViewCell
        return cell

    }
    
}


// MARK: - Extensions

private extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}
