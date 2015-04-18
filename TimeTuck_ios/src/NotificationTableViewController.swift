
//
//  SearchUserTableTableViewController.swift
//  TimeTuck_app
//
//  Created by Greenstein on 2/7/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class NotificationTableViewController: UITableViewController {
    var appManager: TTAppManager?
    var notifications: [[String: AnyObject]]?
    
    init(_ appManager: TTAppManager) {
        self.appManager = appManager;
        super.init(nibName: nil, bundle: nil);
        var nib = UINib(nibName: "FriendCell", bundle: nil);
        tableView.registerNib(nib, forCellReuseIdentifier: "mainCell");
        title = "notifications";
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        var access = TTDataAccess();
        access.notificationList(appManager!.session!) {
            values in
            self.notifications = [];
            
            for v in values {
                self.notifications!.append(v);
            }
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                self.tableView.reloadData();
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notifications != nil {
            return notifications!.count;
        } else {
            return 0;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath) as! FriendCell
        cell.mainLabel!.text = ((notifications![indexPath.row] as [String: AnyObject])["message"] as! String);
        cell.mainLabel!.adjustsFontSizeToFitWidth = true;
        if (!((notifications![indexPath.row] as [String: AnyObject])["was_read"] as! Bool)) {
            cell.backgroundColor = UIColor(red: 151 / 255.0, green: 212 / 255.0, blue: 97 / 255.0, alpha: 1);
        } else {
            cell.backgroundColor = UIColor.whiteColor();
        }
        return cell;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
}
