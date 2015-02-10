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
    
    init(_ appManager: TTAppManager) {
        self.appManager = appManager;
        super.init(nibName: nil, bundle: nil);
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var friends = FriendsTableViewController(appManager!);
        setViewControllers([friends], animated: true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
