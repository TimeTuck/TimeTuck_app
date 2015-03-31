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
    var pic : UIImage!
    var date : NSDate!
    
    
    init(_ appManager: TTAppManager, image: UIImage, datee: NSDate) {
        self.pic = image
        self.date = datee
        self.appManager = appManager
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
        let friends = AddFriendTVC(appManager!, image: pic, datee: date);
        setViewControllers([friends], animated: false);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewWillDisappear() {
        popToRootViewControllerAnimated(true)
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
    

