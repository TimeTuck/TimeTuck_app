//
//  SettingsVC.swift
//  TimeTuck_app
//
//  Created by Cole Scott on 2/7/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    var appManager: TTAppManager?
    var userInfo = NSUserDefaults();
    @IBOutlet weak var errorMessage: UILabel!

    
    var visibleHeight: CGFloat?
    var offset: CGFloat?
    
    init(_ appManager: TTAppManager) {
        super.init(nibName: "SettingsVC", bundle: NSBundle.mainBundle());
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
    
    @IBAction func logout(sender: UIButton) {
        
        var storedSession : AnyObject? = userInfo.objectForKey("session")
        if storedSession != nil {
            var access = TTDataAccess();
            var foundSession = TTSession(storedSession! as [String: String]);
            access.logoutUser(foundSession) {
                successful in
                if (successful == true){
                    var nav = LoginSignUpViewController(self.appManager!);
                    self.presentViewController(nav, animated: true, completion: nil);
                   // self.dismissViewControllerAnimated(true, completion: nil);
                }
                else {
                        println ("This did not work"); }
                }
            
            }
        }
 
    
}

                 
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


