//
//  SearchUsersNavigationController.swift
//  TimeTuck_app
//
//  Created by Greenstein on 2/7/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class SearchUsersNavigationController: StandardNavigationController {
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
        var searchTable = SearchUserTableViewController(self.appManager!);
        setViewControllers([searchTable], animated: true);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return false;
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue);
    }
}
