//
//  ChatCollectionView.swift
//  Stanford-Crushes
//
//  Created by Lawrence Lin Murata on 3/4/15.
//  Copyright (c) 2015 Lawrence Lin Murata. All rights reserved.
//

import UIKit

class ChatViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "chat"
    
    // MARK: UICollectionViewDataSource
    
    //1
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //section 0 is for MatchChat
        //section 1 is for AnonChat
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
    
    //3
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as ChatCell
        cell.backgroundColor = UIColor.whiteColor()
        // Configure the cell
        cell.section = indexPath.section
        cell.row = indexPath.row
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    //1
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            
            /*let flickrPhoto =  photoForIndexPath(indexPath)
            //2
            if var size = flickrPhoto.thumbnail?.size {
                size.width += 10
                size.height += 10
                return size
            }*/
            var width: CGFloat = 100
            var height: CGFloat = 100
            
            var multiplyWidth = 1
            var multiplyHeader = 1
            
           // var convo : Array<String>?
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
            
            //let otherMaxWidth = self.view.bounds.size.width
            
            //println(UIScreen.mainScreen().bounds.size.width)
            //println(self.view.bounds.size.width)
            
            if (array != nil) {
                println("ARRAY NOT NIL")
                var index: Int = array.count - 1 - indexPath.row
                
                var conversations: AnyObject? = array[index].objectForKey("conversation")
                if conversations != nil {
                    var convo = (conversations as? NSArray) as Array?
                    if convo != nil {
               // convo = array[index].objectForKey("conversation") as Array
                        println("MULTIPLYING CONVO")
                        if convo!.count > factor {
                            multiplyHeader *= convo!.count / factor
                            multiplyWidth *= convo!.count / factor

                            if width*CGFloat(multiplyWidth) >= maxWidth{
                                println("RESIZING")
                                multiplyWidth = 1
                                width = maxWidth
                            }
                        }
                    }
                }
            }
            
            return CGSize(width: width*CGFloat(multiplyWidth), height: height*CGFloat(multiplyHeader))
    }
    
    //3
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
}