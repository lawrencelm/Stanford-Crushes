//
//  LoginViewController.swift
//  Stanford-Crushes
//
//  Created by Lawrence Lin Murata on 3/4/15.
//  Copyright (c) 2015 Lawrence Lin Murata. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signup: UIButton!
    
    @IBOutlet weak var login: UIButton!
    
    //@IBOutlet weak var loginBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //image that matches #E74C3C theme
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: view.frame.size))
        imageView.image = UIImage(named: "pic2.jpg")
    
       // loginBackground.opaque = false
       //email.superview?.addSubview(loginBackground)
       //email.superview?.sendSubviewToBack(loginBackground)
        email.superview?.addSubview(imageView)
        email.superview?.sendSubviewToBack(imageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        if email.text != nil && password.text != nil {
            PFUser.logInWithUsername(email.text, password: password.text)
            if PFUser.currentUser() != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)

            }
        }
    }
    
    @IBAction func signupAction(sender: AnyObject) {
        if email.text != nil && password.text != nil {
            var user = PFUser()
            user.username = email.text
            user.password = password.text
            user.email = email.text
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool!, error: NSError!) -> Void in
                if error == nil {
                    self.performSegueWithIdentifier("signupSegue", sender: self)

                    // Hooray! Let them use the app now.
                    //self.messageLabel.text = "User Signed Up";
                } else {
                    // Show the errorString somewhere and let the user try again.
                }
            }
        }
    }
    
}
