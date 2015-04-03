//
//  CapsuleViewController.swift
//  TimeTuck
//
//  Created by Cole Scott on 3/23/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class AddFriendVC: StandardNavigationController {
    
    var appManager: TTAppManager?;
    var capsule : TTTuck!
    
    
    init(_ appManager: TTAppManager, tuck: TTTuck) {
        self.appManager = appManager
        self.capsule = tuck
        super.init(nibName: nil, bundle: nil);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let friends = AddFriendTVC(appManager!, tuck: capsule);
        setViewControllers([friends], animated: false);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        
        /*
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        }
        */
    }
    

