//
//  FriendsNavigationController.swift
//  TimeTuck_app
//
//  Created by Greenstein on 2/5/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class FriendsNavigationController: StandardNavigationController {
    var appManager: TTAppManager?
    var friends: FriendsTableViewController?;
    
    init(_ appManager: TTAppManager) {
        self.appManager = appManager;
        super.init(nibName: nil, bundle: nil);
        friends = FriendsTableViewController(appManager);
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([friends!], animated: false);
    }
    
    func reloadContent() {
        friends!.retrieveFriends();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
