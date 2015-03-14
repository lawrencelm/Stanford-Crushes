//
//  ChatRoomTableViewController.swift
//  Stanford-Crushes
//
//  Created by Lawrence Lin Murata on 3/8/15.
//  Copyright (c) 2015 Lawrence Lin Murata. All rights reserved.
//

import UIKit
import Foundation
import HealthKit // Heart beat functionality
import AVFoundation // Music sharing option


class ChatRoomTableViewController: UITableViewController, UITextFieldDelegate {
    
    override func viewWillDisappear(animated: Bool) {
        // Back button was pressed.
        if player != nil {
            player.pause()
        }
    }
    
    // MARK: - Customized pull-to-refresh view
    
    var refreshLoadingView : UIView!
    var refreshColorView : UIView!
    var stanford_circle : UIImageView!
    var stanford_tree : UIImageView!
    
    var isRefreshIconsOverlap = false
    var isRefreshAnimating = false
    
    
    func setupRefreshControl() {
        
        // Programmatically inserting a UIRefreshControl
        self.refreshControl = UIRefreshControl()
        
        // Setup the loading view, which will hold the moving graphics
        self.refreshLoadingView = UIView(frame: self.refreshControl!.bounds)
        self.refreshLoadingView.backgroundColor = UIColor.clearColor()
        
        // Setup the color view, which will display the rainbowed background
        self.refreshColorView = UIView(frame: self.refreshControl!.bounds)
        self.refreshColorView.backgroundColor = UIColor.clearColor()
        self.refreshColorView.alpha = 0.30
        
        // Create the graphic image views
        stanford_circle = UIImageView(image: UIImage(named: "Stanford-circle.png"))
        self.stanford_tree = UIImageView(image: UIImage(named: "Stanford-tree.png"))
        
        // Add the graphics to the loading view
        self.refreshLoadingView.addSubview(self.stanford_circle)
        self.refreshLoadingView.addSubview(self.stanford_tree)
        
        // Clip so the graphics don't stick out
        self.refreshLoadingView.clipsToBounds = true;
        
        // Hide the original spinner icon
        self.refreshControl!.tintColor = UIColor.clearColor()
        
        // Add the loading and colors views to our refresh control
        self.refreshControl!.addSubview(self.refreshColorView)
        self.refreshControl!.addSubview(self.refreshLoadingView)
        
        // Initalize flags
        self.isRefreshIconsOverlap = false;
        self.isRefreshAnimating = false;
        
        // When activated, invoke our refresh function
        self.refreshControl?.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    // Refresh everything
    func refresh(){
        var delayInSeconds = 3.0;
        var popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)));
        reloadTable()
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            // When done reload, invoke endRefreshing, to close the control
            self.refreshControl!.endRefreshing()
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // Get the current size of the refresh controller
        var refreshBounds = self.refreshControl!.bounds;
        
        // Distance the table has been pulled >= 0
        var pullDistance = max(0.0, -self.refreshControl!.frame.origin.y);
        
        // Half the width of the table
        var midX = self.tableView.frame.size.width / 2.0;
        
        // Calculate the width and height of our graphics
        var compassHeight = self.stanford_circle.bounds.size.height;
        var compassHeightHalf = compassHeight / 2.0;
        
        var compassWidth = self.stanford_circle.bounds.size.width;
        var compassWidthHalf = compassWidth / 2.0;
        
        var spinnerHeight = self.stanford_tree.bounds.size.height;
        var spinnerHeightHalf = spinnerHeight / 2.0;
        
        var spinnerWidth = self.stanford_tree.bounds.size.width;
        var spinnerWidthHalf = spinnerWidth / 2.0;
        
        // Calculate the pull ratio, between 0.0-1.0
        var pullRatio = min( max(pullDistance, 0.0), 100.0) / 100.0;
        
        // Set the Y coord of the graphics, based on pull distance
        var compassY = pullDistance / 2.0 - compassHeightHalf;
        var spinnerY = pullDistance / 2.0 - spinnerHeightHalf;
        
        // Calculate the X coord of the graphics, adjust based on pull ratio
        var compassX = (midX + compassWidthHalf) - (compassWidth * pullRatio);
        var spinnerX = (midX - spinnerWidth - spinnerWidthHalf) + (spinnerWidth * pullRatio);
        
        // When the compass and spinner overlap, keep them together
        if (fabsf(Float(compassX - spinnerX)) < 1.0) {
            self.isRefreshIconsOverlap = true;
        }
        
        // If the graphics have overlapped or we are refreshing, keep them together
        if (self.isRefreshIconsOverlap || self.refreshControl!.refreshing) {
            compassX = midX - compassWidthHalf;
            spinnerX = midX - spinnerWidthHalf;
        }
        
        // Set the graphic's frames
        var compassFrame = self.stanford_circle.frame;
        compassFrame.origin.x = compassX;
        compassFrame.origin.y = compassY;
        
        var spinnerFrame = self.stanford_tree.frame;
        spinnerFrame.origin.x = spinnerX;
        spinnerFrame.origin.y = spinnerY;
        
        self.stanford_circle.frame = compassFrame;
        self.stanford_tree.frame = spinnerFrame;
        
        // Set the encompassing view's frames
        refreshBounds.size.height = pullDistance;
        
        self.refreshColorView.frame = refreshBounds;
        self.refreshLoadingView.frame = refreshBounds;
        
        // If we're refreshing and the animation is not playing, then play the animation
        if (self.refreshControl!.refreshing && !self.isRefreshAnimating) {
            self.animateRefreshView()
        }
        
    }
    
    func animateRefreshView() {
        
        // Background color to loop through for our color view
        
        var colorArray = [UIColor.redColor(), UIColor.blueColor(), UIColor.purpleColor(), UIColor.cyanColor(), UIColor.orangeColor(), UIColor.magentaColor()]
        
        // In Swift, static variables must be members of a struct or class
        struct ColorIndex {
            static var colorIndex = 0
        }
        
        // Flag that we are animating
        self.isRefreshAnimating = true;
        
        UIView.animateWithDuration(
            Double(0.3),
            delay: Double(0.0),
            options: UIViewAnimationOptions.CurveLinear,
            animations: {
                // Rotate the spinner by M_PI_2 = PI/2 = 90 degrees
                self.stanford_tree.transform = CGAffineTransformRotate(self.stanford_tree.transform, CGFloat(M_PI_2))
                
                // Change the background color
                self.refreshColorView!.backgroundColor = colorArray[ColorIndex.colorIndex]
                ColorIndex.colorIndex = (ColorIndex.colorIndex + 1) % colorArray.count
            },
            completion: { finished in
                // If still refreshing, keep spinning, else reset
                if (self.refreshControl!.refreshing) {
                    self.animateRefreshView()
                }else {
                    self.resetAnimation()
                }
            }
        )
    }
    
    func resetAnimation() {
        
        // Reset our flags and }background color
        self.isRefreshAnimating = false;
        self.isRefreshIconsOverlap = false;
        self.refreshColorView.backgroundColor = UIColor.clearColor()
    }
    
    // MARK: - Tap gesture actions:
    
    @IBAction func doubleTapAction(sender: UITapGestureRecognizer) {
        // Pause music
        println("double tap")
        
        if sender.state == .Ended {
            println("double action")
            if player != nil {
                player.pause()
            }
        }
    }
    
    @IBAction func singleTapAction(sender: UITapGestureRecognizer) {
        // Check if state ended
        // Play music
        println("single tap")
        if sender.state == .Ended {
            println("single action")
            if player != nil {
                player.pause()
            }
            
            playRandom()
            firstTime = false
        }
    }
    
    
    
    @IBAction func tripeTapAction(sender: UITapGestureRecognizer) {
        // Send heart beat
        println("triple tap")
        if sender.state == .Ended {
            shareHeartBeatNow()
        }
    }
    
    
    // MARK: - Heart Beat Functionality
    
    private var healthStore = HKHealthStore()
    private let myHeight: Double = 1.7
    
    // Gets data about the user's heart beat stored in the Health Store
    private func getHearRate() -> Int {
        if(HKHealthStore.isHealthDataAvailable()) {
            // Do health stuff
            
            let height = myHeight
            let heartRateUnit: HKUnit = HKUnit.countUnit().unitDividedByUnit(HKUnit.minuteUnit())
            let heartRateQuantity: HKQuantity = HKQuantity(unit: heartRateUnit, doubleValue: height)
            
            var heartRate : HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
            
            println("heart rate is \(heartRate.aggregationStyle.hashValue)")
            println("heart rate is \(heartRate.aggregationStyle.rawValue)")
            
            return heartRate.aggregationStyle.rawValue
        }
        
        return 0
    }
    
    // Shares your heart beat with the person you're talking to
    @IBAction func shareHeartBeatNow(sender: AnyObject) {
        saveHeartRateIntoHealthStore(myHeight)
        var heartRate: Int = getHearRate()
        sendHeartToPerson(heartRate)
    }
    
    private func shareHeartBeatNow() {
        saveHeartRateIntoHealthStore(myHeight)
        var heartRate: Int = getHearRate()
        sendHeartToPerson(heartRate)
    }
    
    // Encodes your heart beat into a string that can be read as a message
    // And will be decoded later.
    private func sendHeartToPerson(heartRate: Int) {
        println("sending my heart rate")
        
        if chat == nil {
            chat = []
        }
        
        var conversation = (chat as? NSArray) as Array?
        
        conversation!.append([PFUser.currentUser().username, "#hb" + String(heartRate)])
        
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
    
    // Measures and stores user's heart beat
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
    
    // MARK: - Music Sharing
    
    private var player : AVAudioPlayer! = nil
    private var firstTime: Bool = true
    private let songType: String = "mp3"
    private let songName: String = "theme"
    private let numSongs: Int = 4
    
    //Instantly starts music sharing for everybody who is
    //connected with the chat room
    
    //So if there is a chat between user 1 and 2. If user 1 turns
    //on music sharing, both users 1 and 2 will start listening to
    //the same music at the same moment, ressembling the feeling of
    //listening to music together with friends in a room (but without
    //being necessarily in the same place)
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
    
    //Stops music sharing
    private func stopSharingMusic() {
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
    
    //Checks if the music sharing functionality is ON
    private func checkPlay() -> Bool {
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
    
    //Play a random song
    private func playRandom() {
        var randomNum : Int = Int(CGFloat.random(numSongs))
        
        //only need this if your first song starts at 1
        
        var song: String = songName + String(randomNum)
        playMusic(song)
    }
    
    //Play a song with the given name
    private func playMusic(song: String) {
        let path = NSBundle.mainBundle().pathForResource(song, ofType: songType)
        let fileURL = NSURL(fileURLWithPath: path!)
        player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        player.prepareToPlay()
        player.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupRefreshControl()
        self.parentViewController?.navigationItem.leftBarButtonItem!.tintColor = UIColor.whiteColor()

        
        //timer reloads table so that every time a user enters a new message,
        //the message instantly appears on screen. Another way to do this would
        //be by using Notifications, but that'd require a very different implementation
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("reloadTable"), userInfo: nil, repeats: true)
        if (firstTime && checkPlay()) {
            firstTime = false
            playRandom()
        }
    }
    
    // Reloads entire table
    func reloadTable() {
        tableView.reloadData()
    }
    
    var needReload : Bool? {
        didSet {
            tableView.reloadData() // Clear out the table view
        }
    }
    
    // Specify data about the chat room
    var chat: AnyObject?
    var chatNum : Int?
    private var convoID: String?
    var type: String?
    
    // Message to be sent
    private var sendMessage: String? {
        didSet {
            sendMessageField?.text = sendMessage
            tableView.reloadData() // Clear out the table view
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
    
    //Sends a message to the person
    //Our chat/messaging functionality works using
    //only 100% iOS SDK elements, except for Parse,
    //which is used to store messages
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
        //0 is for settings/options
        //1 is for messages
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
            //Message
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
        
        //Settings/options:
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
