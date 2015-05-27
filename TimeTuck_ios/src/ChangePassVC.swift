//
//  ChangePassVC.swift
//  TimeTuck
//
//  Created by Cole Scott on 5/26/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class ChangePassVC: UIViewController {
    
    var appManager: TTAppManager?
    @IBOutlet weak var oldPassword: LoginTextFields!
    @IBOutlet weak var password: LoginTextFields!
    @IBOutlet weak var verifyPassword: LoginTextFields!
    
    init(_ appManager: TTAppManager) {
        super.init(nibName: "ChangePassVC", bundle: NSBundle.mainBundle());
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
    
    
    @IBAction func back(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func go(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
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
