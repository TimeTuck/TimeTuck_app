//
//  FeedWebViewController.swift
//  TimeTuck
//
//  Created by Greenstein on 3/14/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit


class FeedWebViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {
    var appManager: TTAppManager?
    var web: UIWebView?
    var scrollOffset: CGFloat?;
    var closedOffsetNav: CGFloat?;
    var openOffsetNav: CGFloat?;
    var startOffset: CGFloat?;
    var cover: UIView!
    var disableHeaderMotion = false;
    var greenColor = UIColor(red: 0.592, green: 0.831, blue: 0.38, alpha: 1);
    var savedInset : UIEdgeInsets?;
    var refrehscontrol = UIRefreshControl()
    
    
    init(_ appManager: TTAppManager) {
        self.appManager = appManager;
        super.init(nibName: nil, bundle: nil);
        title = "Feed";
        web = UIWebView();
        web!.backgroundColor = greenColor;
        web!.delegate = self;
        view = web;
        web?.scrollView.delegate = self;
        web?.scrollView.showsVerticalScrollIndicator = false;
        var t = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50));
        
        t.textAlignment = NSTextAlignment.Center;
        t.text = title;
        t.font = UIFont(name: "Campton-LightDEMO", size: 20)!
        
        navigationItem.titleView = t;
        
        var pressRecognizer = UILongPressGestureRecognizer(target: self, action: "holdDownImage:");
        view.addGestureRecognizer(pressRecognizer);
        
        cover = NSBundle.mainBundle().loadNibNamed("LoadingView", owner: self, options: nil).first as! UIView;
        cover.frame = UIScreen.mainScreen().applicationFrame;
        view.addSubview(cover);
        
        var request = TTWebViews().GetMainFeedRequest(self.appManager!.session!);
        web!.loadRequest(request);
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.appManager = nil;
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        UIView.animateWithDuration(0.2) {
            self.navigationItem.titleView?.alpha = 1;
            return
        }
    }
    
    func holdDownImage(gesture: UILongPressGestureRecognizer) {
        var url = web?.stringByEvaluatingJavaScriptFromString("downLoadImage(\(gesture.locationInView(web).x), \(gesture.locationInView(web).y))");
        if url! != "" && gesture.state == UIGestureRecognizerState.Began {
            var alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet);
            alert.addAction(UIAlertAction(title: "Save Image", style: UIAlertActionStyle.Default) {
                action in
                var data = NSData(contentsOfURL: NSURL(string: url!)!);
                UIImageWriteToSavedPhotosAlbum(UIImage(data: data!)!, nil, nil, nil);
            });
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                action in
                return;
            });
            self.presentViewController(alert, animated: true, completion: nil);
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {        
        if (request.URL!.scheme == "mobile-event") {
            if (request.URL!.host == "fullscreenimage") {
                hideBars();
            } else {
                showBars();
            }
            return false;
        }
        return true;
    }
    
    func hideBars() {
        savedInset = web?.scrollView.contentInset;
        web?.scrollView.bounces = false;
        web?.backgroundColor = UIColor.blackColor();
        disableHeaderMotion = true;
        (parentViewController as! UINavigationController).setNavigationBarHidden(true, animated: true);
        appManager!.shouldAutoRotate = true;
        appManager!.mainTabNav?.tabBar.hidden = true;
        web?.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
    }
    
    func showBars() {
        web?.scrollView.bounces = true;
        web?.backgroundColor = greenColor;
        disableHeaderMotion = false;
        (parentViewController as! UINavigationController).setNavigationBarHidden(false, animated: true);
        appManager!.shouldAutoRotate = false;
        appManager!.mainTabNav?.tabBar.hidden = false;
        if (savedInset != nil) {
            NSLog(savedInset!.top.description);
            web?.scrollView.contentInset = UIEdgeInsets(top: savedInset!.top, left: savedInset!.left, bottom: savedInset!.bottom, right: savedInset!.right);
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIView.animateWithDuration(0.4, animations: {self.cover!.alpha = 0}, completion: {finished in self.cover!.removeFromSuperview()});
        refrehscontrol.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        webView.scrollView.addSubview(refrehscontrol)
        
    }
    
    func finishScroll(willDecelerate decelerate: Bool) {
        if (!decelerate && !disableHeaderMotion) {
            var navView = parentViewController as! FeedNavigationController;
            
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
    
    
    func refresh() {
        web!.reload()
        refrehscontrol.endRefreshing()
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        finishScroll(willDecelerate: false);
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        finishScroll(willDecelerate: decelerate);
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if disableHeaderMotion {
            return
        }
        
        var navView = parentViewController as! FeedNavigationController;
        
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