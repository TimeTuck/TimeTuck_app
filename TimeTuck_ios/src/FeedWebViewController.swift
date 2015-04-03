//
//  FeedWebViewController.swift
//  TimeTuck
//
//  Created by Greenstein on 3/14/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIkit

class FeedWebViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {
    var appManager: TTAppManager?
    var web: UIWebView?
    var scrollOffset: CGFloat?;
    var closedOffsetNav: CGFloat?;
    var openOffsetNav: CGFloat?;
    var startOffset: CGFloat?;
    var cover: UIView!
    
    init(_ appManager: TTAppManager) {
        self.appManager = appManager;
        super.init(nibName: nil, bundle: nil);
        title = "Feed";
        web = UIWebView();
        web!.backgroundColor = UIColor(red: 0.592, green: 0.831, blue: 0.38, alpha: 1);
        web!.delegate = self;
        view = web;
        web?.scrollView.delegate = self;
        var t = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50));
        t.textAlignment = NSTextAlignment.Center;
        t.text = title;
        t.font = UIFont(name: "Campton-LightDEMO", size: 20)!
        
        navigationItem.titleView = t;
        
        cover = NSBundle.mainBundle().loadNibNamed("LoadingView", owner: self, options: nil).first as UIView;
        cover.frame = UIScreen.mainScreen().applicationFrame;
        view.addSubview(cover)
        
        
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
    
    override func viewWillDisappear(animated: Bool) {
        UIView.animateWithDuration(0.2) {
            self.navigationItem.titleView?.alpha = 1;
            return
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIView.animateWithDuration(0.4, animations: {self.cover!.alpha = 0}, completion: {finished in self.cover!.removeFromSuperview()});
    }
    
    func finishScroll(willDecelerate decelerate: Bool) {
        if (!decelerate) {
            var navView = parentViewController as FeedNavigationController;
            
            UIView.animateWithDuration(0.2) {
                if ((self.closedOffsetNav! + navView.navigationBar.frame.origin.y) / self.closedOffsetNav! < 0.7) {
                    navView.navigationBar.frame.origin.y = -self.closedOffsetNav!;
                    self.navigationItem.titleView?.alpha = 0;
                } else {
                    navView.navigationBar.frame.origin.y = self.openOffsetNav!;
                    self.navigationItem.titleView?.alpha = 1;
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        finishScroll(willDecelerate: false);
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        finishScroll(willDecelerate: decelerate);
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var navView = parentViewController as FeedNavigationController;
        
        if (scrollOffset == nil) {
            scrollOffset = scrollView.contentOffset.y;
            closedOffsetNav = navView.navigationBar.frame.size.height - navView.navigationBar.frame.origin.y;
            openOffsetNav = navView.navigationBar.frame.origin.y;
            startOffset = scrollView.contentOffset.y;
        }
        
        var change = scrollOffset! - scrollView.contentOffset.y;
        
        if (scrollView.contentOffset.y + change > startOffset) {
            if (navView.navigationBar.frame.origin.y + change >= -closedOffsetNav! &&
                navView.navigationBar.frame.origin.y + change <= openOffsetNav!) {
                navView.navigationBar.frame = CGRectOffset(navView.navigationBar.frame, 0, change);
                self.navigationItem.titleView?.alpha = (self.closedOffsetNav! + (navView.navigationBar.frame.origin.y + change)) / self.closedOffsetNav!;
            } else if (navView.navigationBar.frame.origin.y + change < -closedOffsetNav!) {
                    navView.navigationBar.frame.origin.y = -self.closedOffsetNav!;
                    self.navigationItem.titleView?.alpha = 0
            } else {
                    navView.navigationBar.frame.origin.y = self.openOffsetNav!;
                    self.navigationItem.titleView?.alpha = 1;
            }
        }
        
        scrollOffset = scrollView.contentOffset.y;
    }
}