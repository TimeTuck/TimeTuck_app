//
//  FeedNavigationController.swift
//  TimeTuck
//
//  Created by Greenstein on 3/14/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class FeedNavigationController: StandardNavigationController {
    var appManager: TTAppManager?;
    var webController: FeedWebViewController?;
    
    init(_ appManager: TTAppManager) {
        self.appManager = appManager;
        super.init(nibName: nil, bundle: nil);
        title = "Feed";
        webController = FeedWebViewController(self.appManager!);
        setViewControllers([webController!], animated: false);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.appManager = nil;
    }
    
    func reloadWeb() {
        webController?.refresh();
    }
}
