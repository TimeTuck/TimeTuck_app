//
//  FriendsNavigationController.swift
//  TimeTuck_app
//
//  Created by Greenstein on 2/5/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class FriendsNavigationController: UINavigationController {
    var appManager: TTAppManager?
    
    init(_ appManager: TTAppManager) {
        self.appManager = appManager;
        super.init(nibName: nil, bundle: nil);
        var val: UIFont = UIFont(name: "Campton-LightDEMO", size: 20)!
        navigationBar.titleTextAttributes = [NSFontAttributeName: val];
        navigationBar.barTintColor = UIColor(red: 151 / 255.0, green: 212 / 255.0, blue: 97 / 255.0, alpha: 1);
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
