//
//  FeedWebViewController.swift
//  TimeTuck
//
//  Created by Greenstein on 3/14/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIkit

class FeedWebViewController: UIViewController {
    var appManager: TTAppManager?
    
    init(_ appManager: TTAppManager) {
        self.appManager = appManager;
        super.init(nibName: nil, bundle: nil);
        title = "Feed";
        
        var web = UIWebView();
        view = web;
        
        web.loadRequest(NSURLRequest(URL: NSURL(string: "http://localhost:8888/")!));
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.appManager = nil;
    }
}
