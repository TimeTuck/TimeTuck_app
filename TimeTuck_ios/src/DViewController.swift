//
//  DViewController.swift
//  TimeTuck
//
//  Created by Cole Scott on 3/12/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class DViewController: UIViewController {
    
    var appManager: TTAppManager?;
    var picture : UIImage?
  
    
    init(_ appManager: TTAppManager, image: UIImage) {
        super.init(nibName: "DViewController", bundle: NSBundle.mainBundle());
        self.picture = image
        self.appManager = appManager
        
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
    

    @IBOutlet weak var datePicker: UIDatePicker!
    
   
    @IBAction func setD(sender: AnyObject) {
    }

    @IBAction func setDate(sender: UIButton) {
        
        let VC = AddFriendViewController(appManager!, image: picture!, datee: datePicker.date)
        
        presentViewController(AddFriendViewController(appManager!, image: picture!, datee: datePicker.date), animated: true, completion: nil)
        
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
