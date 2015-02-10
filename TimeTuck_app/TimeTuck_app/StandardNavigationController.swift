//
//  StandardViewController.swift
//  TimeTuck_app
//
//  Created by Greenstein on 2/9/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class StandardNavigationController: UINavigationController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        var val: UIFont = UIFont(name: "Campton-LightDEMO", size: 20)!
        navigationBar.titleTextAttributes = [NSFontAttributeName: val];
        navigationBar.barTintColor = UIColor(red: 151 / 255.0, green: 212 / 255.0, blue: 97 / 255.0, alpha: 1);

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
