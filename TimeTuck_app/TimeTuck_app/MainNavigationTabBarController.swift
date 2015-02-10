//
//  MainNavigationController.swift
//  TimeTuck_app
//
//  Created by Greenstein on 2/5/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class MainNavigationTabBarController: UITabBarController, UITabBarControllerDelegate {
    var appManager: TTAppManager?
    
    init(_ appManager: TTAppManager) {
        self.appManager = appManager;
        super.init(nibName: nil, bundle: nil);
        delegate = self;
        modalTransitionStyle = UIModalTransitionStyle.CrossDissolve;
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.appManager = nil;
        modalTransitionStyle = UIModalTransitionStyle.CrossDissolve;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        var friends = FriendsNavigationController(self.appManager!);
        friends.title = "friends";
        var settings = SettingsVC(self.appManager!);
        settings.title = "settings";
        setViewControllers([friends, settings], animated: false);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
