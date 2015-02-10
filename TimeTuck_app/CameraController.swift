//
//  CameraController.swift
//  TimeTuck_app
//
//  Created by Greenstein on 2/10/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class CameraController: UIImagePickerController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            sourceType = UIImagePickerControllerSourceType.Camera;
        } else {
            UIAlertView(title: "Error", message: "Your device does not have a camera", delegate: nil, cancelButtonTitle: "Ok").show();
        }


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
