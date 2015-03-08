//
//  MatchViewController.swift
//  Stanford-Crushes
//
//  Created by Lawrence Lin Murata on 3/3/15.
//  Copyright (c) 2015 Lawrence Lin Murata. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //image that matches #E74C3C theme
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: view.frame.size))
        imageView.image = UIImage(named: "pic1.jpg")
        message.superview?.addSubview(imageView)
        message.superview?.sendSubviewToBack(imageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var message: UILabel!
    
    func matchFound(crush: String, user: String) {
        let alert = UIAlertView()
        alert.title = "Match found!"
        alert.message = "You matched with " + crush
        alert.addButtonWithTitle("OK")
        alert.show()
        
        var post = PFObject(className: "MatchChat")
        post.setObject("match", forKey: "type")
        post.setObject([user, crush], forKey: "members")
        post.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            if success! {
                NSLog("Object created with id: \(post.objectId)")
            } else {
                NSLog("%@", error)
            }
        }
    }
    
    func findMatch() {
        var user = PFUser.currentUser()
        var query = PFQuery(className: "CrushList")
        var array = query.findObjects()
        println(array)
        for crushList in array {
            var crushes: AnyObject? = crushList.objectForKey("crushes")
            var crushesArray = (crushes as? NSArray) as Array?
            println(crushesArray)
            if crushesArray != nil {
                for crush in crushesArray! {
                    var crushEmail = crush as String
                    println(crushEmail)

                    if crushEmail == user.email {
                        println("we have a match!")
                        matchFound(crushEmail, user: user.email)
                    }
                }
            }
        }
    }
    
    @IBAction func enteredCrush(sender: UITextField) {
        var user = PFUser.currentUser()
        if user != nil {
            sender.hidden = true
            var array: Array<String>?
            var crushes: AnyObject! = user.objectForKey("crushes")
            if crushes == nil {
                array = [sender.text]
            } else {
                array = (crushes as? NSArray) as Array?
                if array!.count < 5 {
                    array!.append(sender.text)
                }
            }
            user.setObject(array, forKey: "crushes")
            user.save()
            
            var post = PFObject(className: "CrushList")
            
            post.setObject(user.email, forKey: "owner")
            post.setObject(array, forKey: "crushes")
            post.saveInBackgroundWithBlock {
                (success: Bool!, error: NSError!) -> Void in
                if success! {
                    NSLog("Object created with id: \(post.objectId)")
                } else {
                    NSLog("%@", error)
                }
            }
            
            //use graphics to cover
            
            findMatch()
        }

    }
    
}
