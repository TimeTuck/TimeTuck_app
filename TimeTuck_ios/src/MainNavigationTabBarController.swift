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
    var cameraControl = UIViewController();
    
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
        self.tabBar.tintColor = UIColor(red: 109.0/255, green: 155.0/255, blue: 68.0/255, alpha:1.0);
        var friends = FriendsNavigationController(self.appManager!);
        let friendsImg = UIImage(named: "happy");
        friends.tabBarItem = UITabBarItem(title: "friends", image: friendsImg, tag: 1);
        var settings = SettingsVC(self.appManager!);
        let settingImg = UIImage(named: "gears");
        settings.tabBarItem = UITabBarItem(title: "settings", image: settingImg, tag: 3);
        let cameraImg = UIImage(named: "camera");
        cameraControl.tabBarItem = UITabBarItem(title: "camera", image: cameraImg, tag: 2);
        setViewControllers([friends, cameraControl, settings], animated: false);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if viewController == cameraControl {
            var camera = CameraController();
            
            if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
                UIAlertView(title: "Error", message: "Your device does not have a camera", delegate: nil, cancelButtonTitle: "Ok").show();
                return false;
            }
            
            camera.sourceType = UIImagePickerControllerSourceType.Camera;
            presentViewController(CameraController(), animated: true, completion: nil);
            return false;
        } else {
            return true;
        }
    }
}
