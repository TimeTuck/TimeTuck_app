//
//  CapsuleViewController.swift
//  TimeTuck
//
//  Created by Cole Scott on 2/25/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {
    
    var appManager: TTAppManager?;

    @IBOutlet weak var datePicker:UIDatePicker!
    
    
    
    init(_ appManager: TTAppManager) {
        super.init(nibName: "DateViewController", bundle: NSBundle.mainBundle());
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func encapsule(sender: UIButton) {
        
        presentViewController(AddFriendViewController(appManager!), animated: true, completion: nil)
       
        
        
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
