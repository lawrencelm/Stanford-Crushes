//
//  WriteViewController.swift
//  Stanford-Crushes
//
//  Created by Lawrence Lin Murata on 3/2/15.
//  Copyright (c) 2015 Lawrence Lin Murata. All rights reserved.
//
//  Detail: The problem with MFMailComposeViewController
//  is that there is no way to set the "from" field in the e-mail,
//  so it's only going to be the e-mail account that is connected
//  to the phone. Ideally, the e-mail feature would be 100%
//  anonymous and send an e-mail from a "Stanford Crushes" account.
//  That would require a standalone e-mail client. I chose to
//  use a solution that relies 100% only on the iOS SDK for
//  the purposes of my project since it's a major feature not
//  covered in lecture. I plan to change it to make
//  it more anonymous before I upload it
//  into the App Store.

import UIKit
import MessageUI
import Foundation

class WriteViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate
{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        if let mtvc = destination as? CrushesTableViewController {
            //means that clicked post
            if postText != nil && postText.text != "" {
                writePost()
            } else {
                alertEmpty()
            }
            mtvc.needReload = true
        }
    }
    
    func alertEmpty() {
        let alert = UIAlertView()
        alert.title = "Empty post!"
        alert.message = "You cannot make empty posts."
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    func writePost() {
        var post = PFObject(className: "AnonCrush")
        post.setObject(postText.text, forKey: "post")
        
        if email != nil && email.text != "" {
            post.setObject(email.text, forKey: "crush_email")
            post.setObject(true, forKey: "set_name")
            sendMail()
        } else {
            post.setObject(false, forKey: "set_name")
        }
        post.setObject(0, forKey: "upvotes")
        post.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            if success! {
                NSLog("Object created with id: \(post.objectId)")
            } else {
                NSLog("%@", error)
            }
        }
    }
    
    @IBOutlet weak var postText: UITextField!
    
    @IBOutlet weak var email: UITextField!
    // MARK: - Public API
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //postText.delegate = self
        //email.delegate = self
        self.parentViewController?.title = "Top posts";
        var rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target:self, action: "composeButton")
        self.parentViewController?.navigationItem.rightBarButtonItem = rightBarButton;
        rightBarButton.action = "buttonAction:"
        rightBarButton.target = self
        refresh()
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([email.text])
        mailComposerVC.setSubject("Somebody has a crush on you!")
        mailComposerVC.setMessageBody(postText.text, isHTML: true)
        
        return mailComposerVC
    }
    
    func sendMail() {
        var mailComposeViewController = configuredMailComposeViewController()

        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func unwindToRecent(segue: UIStoryboardSegue) {
        
    }
    
    func buttonAction(sender: UIButton!){
        performSegueWithIdentifier("bogus", sender:self)
    }
    
    // MARK: - Refreshing
    
    // store the searchText into a dictionary in NSUserDefaults
    func refresh() {

    }
    
    // MARK: - Storyboard Connectivity

}
