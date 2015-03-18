//
//  FeedWebViewController.swift
//  TimeTuck
//
//  Created by Greenstein on 3/14/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIkit

class FeedWebViewController: UIViewController, UIWebViewDelegate {
    var appManager: TTAppManager?
    var web: UIWebView?
    
    init(_ appManager: TTAppManager) {
        self.appManager = appManager;
        super.init(nibName: nil, bundle: nil);
        title = "Feed";
        
        web = UIWebView();
        web!.backgroundColor = UIColor.whiteColor();
        web!.scrollView.bounces = false;
        web!.delegate = self;
        view = web;
        
        var request = TTWebViews().GetMainFeedRequest(self.appManager!.session!);
        
        web!.loadRequest(request);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.appManager = nil;
    }
    
    override func viewWillAppear(animated: Bool)
    {
        web!.stringByEvaluatingJavaScriptFromString("document.getElementById(\"find\").innerHTML = \"test\"");
    }
}
