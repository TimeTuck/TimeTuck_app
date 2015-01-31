//
//  LoginViewController.swift
//  TimeTuck_app
//
//  Created by Greenstein on 1/28/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var appManager: TTAppManager?
    @IBOutlet weak var username: LoginTextFields!
    @IBOutlet weak var password: LoginTextFields!
    @IBOutlet weak var errorMessage: UILabel!
    
    init(_ appManager: TTAppManager) {
        super.init(nibName: "LoginViewController", bundle: NSBundle.mainBundle());
        self.appManager = appManager;
        modalTransitionStyle = UIModalTransitionStyle.CrossDissolve;
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.appManager = nil;
        modalTransitionStyle = UIModalTransitionStyle.CrossDissolve;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard");
        view.addGestureRecognizer(tap);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var height = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() as CGRect!;
        var visibleHeight = view.frame.height - height.size.height;
        var textBoxHeight: CGFloat!;
        var textBoxPosition: CGFloat!;
        
        for item in view.subviews {
            if item.isFirstResponder() {
                textBoxHeight = item.frame.height;
                textBoxPosition = item.frame.origin.y;
                break;
            }
        }
        
        if (textBoxPosition != nil && textBoxHeight != nil) {
            var center = (visibleHeight - textBoxHeight) / 2;
            var offset = textBoxPosition -  center;
            if (offset > 0) {
                view.frame.origin.y -= offset;
            }
        }
    }
    
    @IBAction func login(sender: UIButton) {
        var access = TTDataAccess();
        access.loginUser(username.text, password: password.text) {
            user, session in
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                if (user != nil && session != nil) {
                    self.errorMessage.text = "Logged in";
                } else {
                    self.errorMessage.text = "Username or password is incorrect";
                }
                
            }
        }
    }

    @IBAction func back(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    func dismissKeyboard() {
        view.endEditing(true);
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
