//
//  FriendsTableViewController.swift
//  TimeTuck_app
//
//  Created by Greenstein on 2/6/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    var appManager: TTAppManager?
    var friends: [[String: AnyObject]]?
    var requests: [[String: AnyObject]]?
    var friendSect = 0;
    var touching = false;
    
    init(_ appManager: TTAppManager) {
        self.appManager = appManager;
        super.init(nibName: "FriendsTableViewController", bundle: NSBundle.mainBundle());
        title = "friends";
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        var nib = UINib(nibName: "FriendCell", bundle: nil);
        var nibResponse = UINib(nibName: "FriendResponseTableCell", bundle: nil);
        tableView.registerNib(nib, forCellReuseIdentifier: "mainCell");
        tableView.registerNib(nibResponse, forCellReuseIdentifier: "responseCell");
        var addFriendButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addFriends");
        addFriendButton.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = addFriendButton;
        tableView.delegate = self;
        
        var touch = UITapGestureRecognizer(target: self, action: "touched:");
        var touch1 = UIPanGestureRecognizer(target: self, action: "touched:");
        self.view.addGestureRecognizer(touch);
        self.view.addGestureRecognizer(touch1);
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        retrieveFriends();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   func touched(gestureRecognizer: UIGestureRecognizer) {
        if (!touching) {
            touching = true;
            appManager!.removeBadge("friend_all");
        }
        
        if (gestureRecognizer.state == UIGestureRecognizerState.Ended) {
            touching = false;
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var sections: Int = 0;
        
        if (friends != nil && friends!.count > 0) {
            ++sections;
            friendSect = 0
        }
        if (requests != nil && requests!.count > 0) {
            ++sections;
            friendSect = 1;
        }
        return sections;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == friendSect {
            if friends != nil {
                return friends!.count;
            } else {
                return 0;
            }
        } else {
            if requests != nil {
                return requests!.count;
            } else {
                return 0;
            }
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?;
        
        if indexPath.section == friendSect {
            cell = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath) as? UITableViewCell;
            (cell as! FriendCell).mainLabel!.text = ((friends![indexPath.row] as [String: AnyObject])["username"] as! String)
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("responseCell", forIndexPath: indexPath) as? UITableViewCell;
            (cell as! FriendResponseTableCell).usernameLabel!.text = ((requests![indexPath.row] as [String: AnyObject])["username"] as! String)
            (cell as! FriendResponseTableCell).accept!.addTarget(self, action: "acceptRequest:", forControlEvents: UIControlEvents.TouchUpInside);
            (cell as! FriendResponseTableCell).decline!.addTarget(self, action: "declineRequest:", forControlEvents: UIControlEvents.TouchUpInside);
            (cell as! FriendResponseTableCell).accept!.tag = ((requests![indexPath.row] as [String: AnyObject])["id"] as! Int);
            (cell as! FriendResponseTableCell).decline!.tag = ((requests![indexPath.row] as [String: AnyObject])["id"] as! Int);
        }

        return cell!;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section != friendSect) {
            return "requests";
        } else {
            return "friends";
        }
    }
    
   // Unfinished implementation of delete friends
   /*
    
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            switch editingStyle {
            case .Delete:
                // remove the deleted item from the model
                //self.items.removeAtIndex(indexPath.row)
                // remove the deleted item from the `UITableView`
                //self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            default:
                return
            }
    }
    
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    */

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
    func addFriends() {
        var searchUsers = SearchUsersNavigationController(self.appManager!);
        self.presentViewController(searchUsers, animated: false, completion: nil);
    }
    
    func acceptRequest(sender: UIControl) {
        var access = TTDataAccess();
        access.respondFriendRequest(self.appManager!.session!, respondedFriend: sender.tag, accept: true, completed: responseComplete);
    }
    
    func declineRequest(sender: UIControl) {
        var access = TTDataAccess();
        access.respondFriendRequest(self.appManager!.session!, respondedFriend: sender.tag, accept: false, completed: responseComplete);
    }
    
    func responseComplete(status: Int?) {
        if (status != nil && status == 0) {
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                self.retrieveFriends();
            };
        } else if (status != nil && status == 2) {
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                UIAlertView(title: "Error", message: "An error occured, please try again", delegate: nil, cancelButtonTitle: "OK").show();
            };
        }
    }
    
    func retrieveFriends() {
        var access = TTDataAccess();
        access.getFriends(appManager!.session!) {
            friends, requests in
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                self.friends = friends;
                self.requests = requests;
                self.tableView.reloadData();
            }
        }
    }
}