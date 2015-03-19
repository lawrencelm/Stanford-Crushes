//
//  CrushesTableViewController.swift
//  Stanford-Crushes
//
//  Created by Lawrence Lin Murata on 3/2/15.
//  Copyright (c) 2015 Lawrence Lin Murata. All rights reserved.
//
//  Citations: Stackoverflow discussion on how to use hex values for colors
//  Citations: Tutorial on how to make animated and customized pull-to-refresh view form Jackrabbit Mobile
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
            tableView.reloadData() // Clear out the table view
        }
    }
    
    //Allows auto reload of the data/posts every 10 seconds
    func reloadTable() {
        
        tableView.reloadData() // clear out the table view
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupRefreshControl()
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("reloadTable"), userInfo: nil, repeats: true)
        
        self.parentViewController?.title = "Recent";
        var rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target:self, action: "composeButton")
        self.parentViewController?.navigationItem.rightBarButtonItem = rightBarButton;
        rightBarButton.action = "buttonAction:"
        rightBarButton.target = self
        
        self.navigationController?.navigationBar.barTintColor = UIColor(netHex: 0xF3726D)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
    }
    
    
    @IBAction func unwindToRecent(segue: UIStoryboardSegue) {
        
    }
    
    func buttonAction(sender: UIButton!){
        performSegueWithIdentifier("bogus", sender:self)
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
        //Rows for anonymous posts
        var query = PFQuery(className: "AnonCrush")
        var array = query.findObjects()
        if array != nil {
            if array.count < 100 {
                return array.count
            } else {
                return 100
            }
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as CrushesTableViewCell
        
        cell.row = indexPath.row
        
        return cell
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
    
    func refresh(){
        var delayInSeconds = 3.0;
        var popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)));
        reloadTable()
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            // When done reloading, invoke endRefreshing, to close the control
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
}

