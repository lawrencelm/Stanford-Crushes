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
        message.superview?.sendSubviewToBack(imageView)    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var message: UILabel!
    
    @IBAction func enteredCrush(sender: UITextField) {
        //limit to 5
    }
    
}
