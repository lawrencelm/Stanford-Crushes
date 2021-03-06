//
//  ChatCollectionView.swift
//  Stanford-Crushes
//
//  Created by Lawrence Lin Murata on 3/4/15.
//  Copyright (c) 2015 Lawrence Lin Murata. All rights reserved.
//
//  Citations: App Coda tutorial on how to use Fingerprint ID Authentication
//

import UIKit
import LocalAuthentication


class ChatViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate {
    
    private let reuseIdentifier = "chat"
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        if let mtvc = destination as? ChatRoomTableViewController {
            // Means that clicked post
            
            println("SEGUE")
            
            row = (self.collectionView?.indexPathForCell(sender as UICollectionViewCell)?.row)!
            var curSection = (self.collectionView?.indexPathForCell(sender as UICollectionViewCell)?.section)!
                
            mtvc.chatNum  = row
            println(mtvc.chatNum)
            if curSection == 0 {
                mtvc.type = "MatchChat"
                println("MatchChatXYZ")
            } else {
                mtvc.type = "AnonChat"
                println("AnonChatXYZ")
            }
            mtvc.needReload = true
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    var row = Int()
    var section = Int()
    
    //1
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // Section 0 is for MatchChat
        // Section 1 is for AnonChat
        return 2
    }
    
    //2
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            var query = PFQuery(className: "MatchChat")
            var array = query.findObjects()
            if array.count < 100 {
                return array.count
            } else {
                return 100
            }
        } else {
            var query = PFQuery(className: "AnonChat")
            var array = query.findObjects()
            if array.count < 100 {
                return array.count
            } else {
                return 100
            }
        }
    }
    
    private var numPics = 31 // Number of pics available
    private var imageType = ".png"
    private var imageName = "icon"
    
    //3
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as ChatCell
        
        // Configure the cell
        
        row = indexPath.row
        section = indexPath.section
        
        cell.section = indexPath.section
        
        if indexPath.section == 0 {
            var query = PFQuery(className: "MatchChat")
            var array = query.findObjects()
            var index: Int = array.count - 1 - indexPath.row
            cell.chat = array[index]
            
            println("matchxyz")
            println(array[index])

        } else {
            var query = PFQuery(className: "AnonChat")
            var array = query.findObjects()
            var index: Int = array.count - 1 - indexPath.row
            cell.chat = array[index]
            
            println("anonxyz")
            println(array[index])
        }
        
        var randomNum : Int = Int(CGFloat.random(numPics))
        
        //only need this if your first picture starts at 1
        /*if randomNum == 0 {
            randomNum++
        }*/
        
        var picName: String = imageName + String(randomNum) + imageType
        println(picName)
        
        cell.imageView.image = UIImage(named: picName)
        cell.imageView.sizeThatFits(cell.bounds.size)
        
        cell.row = indexPath.row
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    // Sets up the size of each cell, which varies according to
    // How important each chat is (measure through number of messages).
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            
            var width: CGFloat = 100
            var height: CGFloat = 100
            
            var multiplyWidth = 1
            var multiplyHeader = 1
            
            var index = Int()
            var classType = String()
            
            if indexPath.section == 0 {
                //MatchChat
                classType = "MatchChat"
            } else {
                //AnonChat
                classType = "AnonChat"
            }
            
            var query = PFQuery(className: classType)
            var array = query.findObjects()
            let factor = 5
            let margin = 20
            let maxWidth = UIScreen.mainScreen().bounds.size.width - 2*CGFloat(margin)

            
            if (array != nil) {
                println("ARRAY NOT NIL")
                var index: Int = array.count - 1 - indexPath.row
                
                var conversations: AnyObject? = array[index].objectForKey("conversation")
                if conversations != nil {
                    var convo = (conversations as? NSArray) as Array?
                    if convo != nil {
                        println("MULTIPLYING CONVO")
                        if convo!.count > factor {
                            multiplyHeader *= convo!.count / factor
                            multiplyWidth *= convo!.count / factor

                            if width*CGFloat(multiplyWidth) >= maxWidth{
                                println("RESIZING")
                                
                                multiplyHeader = 1
                                height = maxWidth
                                
                                multiplyWidth = 1
                                width = maxWidth
                            }
                        }
                    }
                }
            }
            
            return CGSize(width: width*CGFloat(multiplyWidth), height: height*CGFloat(multiplyHeader))
    }
    
    // Edge insets
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    // MARK: - ID Authentication
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.barTintColor = UIColor(netHex: 0xF3726D)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // Just for testing:
        //defaults.setObject(true, forKey: "auth")
        
        if((defaults.objectForKey("auth") == nil) || (defaults.objectForKey("auth") as Bool)) {
            authenticateUser()
        }
    }
    
    func showPasswordAlert() {
        var passwordAlert : UIAlertView = UIAlertView(title: "TouchID", message: "Please type your password", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Okay")
        passwordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
        passwordAlert.show()
    }
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            if !alertView.textFieldAtIndex(0)!.text.isEmpty {
                if alertView.textFieldAtIndex(0)!.text == "appcoda" {
                    
                }
                else{
                    showPasswordAlert()
                }
            }
            else{
                showPasswordAlert()
            }
        }
    }
    
    func authenticateUser() {
        // Get the local authentication context.
        let context = LAContext()
        
        // Declare a NSError variable.
        var error: NSError?
        
        // Set the reason string that will appear on the authentication alert.
        var reasonString = "Authentication is needed to access your notes."
        
        // Check if the device can evaluate the policy.
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            [context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                
                if success {
                    
                }
                else{
                    // If authentication failed then show a message to the console with a short description.
                    // In case that the error is a user fallback, then show the password alert view.
                    println(evalPolicyError?.localizedDescription)
                    
                    switch evalPolicyError!.code {
                        
                    case LAError.SystemCancel.rawValue:
                        println("Authentication was cancelled by the system")
                        
                    case LAError.UserCancel.rawValue:
                        println("Authentication was cancelled by the user")
                        
                    case LAError.UserFallback.rawValue:
                        println("User selected to enter custom password")
                        self.showPasswordAlert()
                        
                    default:
                        println("Authentication failed")
                        self.showPasswordAlert()
                    }
                }
                
            })]
        }
        else{
            // If the security policy cannot be evaluated then show a short message depending on the error.
            switch error!.code{
                
            case LAError.TouchIDNotEnrolled.rawValue:
                println("TouchID is not enrolled")
                
            case LAError.PasscodeNotSet.rawValue:
                println("A passcode has not been set")
                
            default:
                // The LAError.TouchIDNotAvailable case.
                println("TouchID not available")
            }
            
            // Optionally the error description can be displayed on the console.
            println(error?.localizedDescription)
            
            // Show the custom alert view to allow users to enter the password.
            self.showPasswordAlert()
        }
    }

}

// MARK: - Extensions

private extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}