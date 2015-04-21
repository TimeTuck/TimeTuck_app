//
//  MainNavigationController.swift
//  TimeTuck_app
//
//  Created by Greenstein on 2/5/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class MainNavigationTabBarController: UITabBarController, UITabBarControllerDelegate {
    var cameraControl = UIViewController();
    var appManager: TTAppManager?
    var feed: FeedNavigationController?;
    var friends: FriendsNavigationController?;
    var settings: SettingsVC?;
    var notifications: NotificationsNavigationController?;
    
    init(_ appManager: TTAppManager) {
        self.appManager = appManager;
        super.init(nibName: nil, bundle: nil);
        delegate = self;
        modalTransitionStyle = UIModalTransitionStyle.CrossDissolve;
        self.appManager?.mainTabNav = self;
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.appManager = nil;
        modalTransitionStyle = UIModalTransitionStyle.CrossDissolve;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tabBar.tintColor = UIColor(red: 109.0/255, green: 155.0/255, blue: 68.0/255, alpha:1.0);
        feed = FeedNavigationController(self.appManager!);
        let feedImg = UIImage(named: "picture");
        feed!.tabBarItem = UITabBarItem(title: "feed", image: feedImg, tag: 1);
        friends = FriendsNavigationController(self.appManager!);
        let friendsImg = UIImage(named: "happy");
        friends!.tabBarItem = UITabBarItem(title: "friends", image: friendsImg, tag: 1);
        notifications = NotificationsNavigationController(self.appManager!);
        let notificationImg = UIImage(named: "flag");
        notifications!.tabBarItem = UITabBarItem(title: "notifications", image: notificationImg, tag: 4);
        settings = SettingsVC(self.appManager!);
        let settingImg = UIImage(named: "gears");
        settings!.tabBarItem = UITabBarItem(title: "settings", image: settingImg, tag: 3);
        let cameraImg = UIImage(named: "camera");
        cameraControl.tabBarItem = UITabBarItem(title: "camera", image: cameraImg, tag: 2);
        setViewControllers([friends!, feed!, cameraControl, notifications!, settings!], animated: false);
        selectedIndex = 1;
        
        appManager?.refreshBadges();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if viewController == cameraControl {
            var camera = CameraController.initialize(appManager!);
            
            if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
                UIAlertView(title: "Error", message: "Your device does not have a camera", delegate: nil, cancelButtonTitle: "Ok").show();
                return false;
            }
            
            camera.sourceType = UIImagePickerControllerSourceType.Camera;
            presentViewController(camera, animated: true, completion: nil);
            return false;
        } else {
            return true;
        }
    }
    
    override func shouldAutorotate() -> Bool {
        if appManager == nil {
            return true;
        } else {
            if !appManager!.shouldAutoRotate {
                if UIApplication.sharedApplication().statusBarOrientation != UIInterfaceOrientation.Portrait {
                    return true;
                }
            }
            return appManager!.shouldAutoRotate;
        }
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if appManager!.shouldAutoRotate {
            return Int(UIInterfaceOrientationMask.All.rawValue);
        }
        
        return Int(UIInterfaceOrientationMask.Portrait.rawValue);
    }
}