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
        var val: UIFont = UIFont(name: "Campton", size: 20)!
        navigationBar.titleTextAttributes = [NSFontAttributeName: val];
        navigationBar.barTintColor = UIColor(red: 151 / 255.0, green: 212 / 255.0, blue: 97 / 255.0, alpha: 1);
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}