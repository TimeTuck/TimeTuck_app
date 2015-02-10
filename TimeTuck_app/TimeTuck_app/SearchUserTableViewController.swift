//
//  SearchUserTableTableViewController.swift
//  TimeTuck_app
//
//  Created by Greenstein on 2/7/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class SearchUserTableViewController: UITableViewController, UISearchBarDelegate {
    var appManager: TTAppManager?
    var searchBar: UISearchBar?;
    var users: [[String: AnyObject]]?
    
    init(_ appManager: TTAppManager) {
        self.appManager = appManager;
        searchBar = UISearchBar(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 40)));
        super.init(nibName: "SearchUserTableViewController", bundle: NSBundle.mainBundle());
        var nib = UINib(nibName: "RequestFriendCell", bundle: nil);
        tableView.registerNib(nib, forCellReuseIdentifier: "mainCell");
        title = "search users";
        searchBar?.delegate = self;
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var exit = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "exit");
        navigationItem.setLeftBarButtonItem(exit, animated: true);
        tableView.tableHeaderView = searchBar!;
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func exit() {
        dismissViewControllerAnimated(false, completion: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users != nil {
            return users!.count;
        } else {
            return 0;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath) as RequestFriendCell
        cell.usernameLabel!.text = ((users![indexPath.row] as [String: AnyObject])["username"] as String);
        cell.requestButton!.tag = ((users![indexPath.row] as [String: AnyObject])["id"] as Int);
        cell.requestButton!.addTarget(self, action: "sendRequest:", forControlEvents: UIControlEvents.TouchUpInside);
        return cell;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        var access = TTDataAccess();
        access.searchUsers(appManager!.session!, search: searchText) {
            users in
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                self.users = users;
                self.tableView.reloadData();
            };
        };
    }
    
    func sendRequest(sender: UIButton) {
        var access = TTDataAccess();
        access.sendFriendRequest(appManager!.session!, requestedFriend: sender.tag) {
            status in
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                if (status != nil && status == 0) {
                    UIAlertView(title: "Request Sent!", message: "A request has been sent", delegate: nil, cancelButtonTitle: "Ok").show();
                } else if (status != nil && status == 1){
                    UIAlertView(title: "Request Already Sent", message: "You have already sent a friend request", delegate: nil, cancelButtonTitle: "Ok").show();
                } else {
                    UIAlertView(title: "Something Broke!", message: "The request cannot be sent, please try again", delegate: nil, cancelButtonTitle: "Ok").show();
                }
            };
        };
    }
}
