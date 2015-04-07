//
//  FriendsTableViewController.swift
//  TimeTuck_app
//
//  Created by Cole Scott on 3/26/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class AddFriendTVC: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    var appManager: TTAppManager?
    var capsule : TTTuck!
    
    var friends: [[String: AnyObject]]?
    
    
    init(_ appManager: TTAppManager, tuck: TTTuck) {
        self.appManager = appManager;
        self.capsule = tuck
        
        super.init(nibName: "AddFriendTVC", bundle: NSBundle.mainBundle());
        title = "share with friends";
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        var nib = UINib(nibName: "FriendCell", bundle: nil);
        tableView.registerNib(nib, forCellReuseIdentifier: "mainCell");
        var tuckButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "tuck");
        tuckButton.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = tuckButton;
        self.tableView.allowsMultipleSelection = true;
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        retrieveFriends();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if friends != nil {
                return friends!.count;
            } else {
                return 0;
            }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?;
        
            cell = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath) as? UITableViewCell;
            (cell as FriendCell).mainLabel!.text = ((friends![indexPath.row] as [String: AnyObject])["username"] as String)
        (cell as FriendCell).mainLabel!.tag = ((friends![indexPath.row] as [String: AnyObject])["id"] as Int);
    
        return cell!;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
    func tuck() {
        
        let userID = appManager!.getUserID()
        capsule.addUsers(userID)
        
        if let index = tableView.indexPathsForSelectedRows() {
            for var i = 0; i < index.count; ++i {
                
                var thisPath = index[i] as NSIndexPath
                var cell = tableView.cellForRowAtIndexPath(thisPath)
                capsule.addUsers(((cell as FriendCell).mainLabel!.tag))
            }
        }
        
        var data = TTDataAccess();
        data.upload_image(appManager!.session!, imageData: UIImagePNGRepresentation(compressImage(capsule.picture!, scale: 0.20)), untuckDate: capsule.date!, users: capsule.shareusers) {
            NSLog("Uploaded");
        };
        
        
        presentViewController(MainNavigationTabBarController(appManager!), animated: true, completion: nil)

    }
    
    func retrieveFriends() {
        var access = TTDataAccess();
        access.getFriends(appManager!.session!) {
            friends, requests in
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                self.friends = friends;
                self.tableView.reloadData();
            }
        }
    }

    func compressImage(image: UIImage, scale: CGFloat) -> UIImage {
        var originalSize = image.size;
        var newRect = CGRectMake(0, 0, originalSize.width * scale, originalSize.height * scale);
        
        UIGraphicsBeginImageContext(newRect.size);
        image.drawInRect(newRect);
        var newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    

}