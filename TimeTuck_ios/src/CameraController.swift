//
//  CameraController.swift
//  TimeTuck_app
//
//  Created by Greenstein on 2/10/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class CameraController: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var appManager: TTAppManager?;
    
    class func initialize(appManager: TTAppManager) -> CameraController {
        var camera = CameraController();
        camera.appManager = appManager;
        return camera;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        var data = TTDataAccess();
        data.upload_image(appManager!.session!, imageData: UIImagePNGRepresentation(image));
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
