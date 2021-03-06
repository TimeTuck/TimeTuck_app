//
//  LoginViewController.swift
//  TimeTuck_app
//
//  Created by Greenstein on 1/28/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class LoginSignUpViewController: UIViewController {
    var appManager: TTAppManager?;
    
    init(_ appManager: TTAppManager) {
        super.init(nibName: "LoginSignupViewController", bundle: NSBundle.mainBundle());
        self.appManager = appManager;
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.appManager = nil;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: UIButton) {
        let loginViewController = LoginViewController(appManager!);
        presentViewController(loginViewController, animated: true, completion: nil);
        
    }

    @IBAction func signup(sender: AnyObject) {
        let signUpViewController = SignUpViewController(appManager!);
        presentViewController(signUpViewController, animated: true, completion: nil);
    }
    
    override func shouldAutorotate() -> Bool {
        return false;
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue);
    }
}
