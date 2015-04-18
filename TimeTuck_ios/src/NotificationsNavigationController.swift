//
//  SearchUsersNavigationController.swift
//  TimeTuck_app
//
//  Created by Greenstein on 2/7/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class NotificationsNavigationController: StandardNavigationController {
    var appManager: TTAppManager?
    init(_ appManager: TTAppManager) {
        self.appManager = appManager;
        super.init(nibName: nil, bundle: nil);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.appManager = nil;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        var notificationTable = NotificationTableViewController(self.appManager!);
        setViewControllers([notificationTable], animated: true);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
