//
//  CrushesTableViewController.swift
//  Stanford-Crushes
//
//  Created by Lawrence Lin Murata on 3/2/15.
//  Copyright (c) 2015 Lawrence Lin Murata. All rights reserved.
//

import UIKit


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class CrushesTableViewController: UITableViewController, UITextFieldDelegate
{
    
    var needReload : Bool? {
        didSet {
            tableView.reloadData() // clear out the table view
            refresh()
        }
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        
        /*var user = PFUser()
        user.username = "myUsername"
        user.password = "myPassword"
        user.email = "lmurata@stanford.edu"
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
                //self.messageLabel.text = "User Signed Up";
            } else {
                // Show the errorString somewhere and let the user try again.
            }
        }*/
        
        super.viewDidLoad()
        
        self.parentViewController?.title = "Recent";
        var rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target:self, action: "composeButton")
        self.parentViewController?.navigationItem.rightBarButtonItem = rightBarButton;
        rightBarButton.action = "buttonAction:"
        rightBarButton.target = self
        refresh()
        
        //self.navigationController?.navigationBar.tintColor = UIColor.purpleColor()
        //self.navigationItem.backBarButtonItem?.tintColor = UIColor.purpleColor()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(netHex: 0xF3726D)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
     //   setupViewController(1)
    }
    
   /* func setupViewController(index: Int) {
        let vas CrushesNavigationViewController
        //vc.podcast = podcast
        vc.tabBarItem.title = "Episode"
        //vc.tabBarItem.image = UIImage(named: "png")
    }*/
    
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
    
    
    private struct Storyboard {
        static let CellReuseIdentifier = "crush"
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as CrushesTableViewCell
        
        cell.row = indexPath.row
        
        return cell
    }
}

