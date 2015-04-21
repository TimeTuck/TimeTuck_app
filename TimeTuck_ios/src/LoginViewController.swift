//
//  LoginViewController.swift
//  TimeTuck_app
//
//  Created by Greenstein on 1/28/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    var appManager: TTAppManager?
    @IBOutlet weak var username: LoginTextFields!
    @IBOutlet weak var password: LoginTextFields!
    @IBOutlet weak var errorMessage: UILabel!
    
    var visibleHeight : CGFloat?
    var offset: CGFloat?
    
    init(_ appManager: TTAppManager) {
        super.init(nibName: "LoginViewController", bundle: NSBundle.mainBundle());
        initialize(appManager);
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        initialize(nil);
    }
    
    func initialize(appManager: TTAppManager?) {
        offset = 0;
        self.appManager = appManager;
        modalTransitionStyle = UIModalTransitionStyle.CrossDissolve;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard");
        view.addGestureRecognizer(tap);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil);
        
        username.delegate = self;
        password.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var height = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() as CGRect!;
        visibleHeight = UIScreen.mainScreen().bounds.height - height.size.height;
        for item in view.subviews {
            if item.isFirstResponder() {
                updateTextFieldPosition(item as! UITextField);
                break;
            }
        }
    }
    
    func keyboardWillHide() {
        offset = 0;
        visibleHeight = nil;
        UIView.animateWithDuration(0.2) {
            self.view.frame.origin.y = 0;
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        updateTextFieldPosition(textField);
        
    }
    
    func updateTextFieldPosition(textfield: UITextField) {
        var textBoxHeight: CGFloat!;
        var textBoxPosition: CGFloat!;
        
        textBoxHeight = textfield.frame.height;
        textBoxPosition = textfield.frame.origin.y;
        
        UIView.animateWithDuration(0.2) {
            if (textBoxPosition != nil && textBoxHeight != nil && self.visibleHeight != nil) {
                var center = (self.visibleHeight! - textBoxHeight) / 2;
                self.offset = textBoxPosition -  center;
                if (self.offset! < 0) {
                    self.view.frame.origin.y = 0;
                    self.offset = 0;
                } else {
                    self.view.frame.origin.y = self.offset! * -1;
                }
            }
        }
    }
    
    @IBAction func login(sender: UIButton) {
        var access = TTDataAccess();
        view.endEditing(true);
        
        access.loginUser(username.text, password: password.text, deviceToken: appManager?.deviceToken) {
            user, session in
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                if (user != nil && session != nil) {
                    var token = self.appManager?.deviceToken;
                    self.appManager?.session = session!
                    self.appManager?.user = user!;
                    self.appManager!.deviceToken = token;
                    self.appManager!.saveSession();
                    var nav = MainNavigationTabBarController(self.appManager!);
                    self.presentViewController(nav, animated: true, completion: nil);
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
    
    override func shouldAutorotate() -> Bool {
        return false;
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait;
    }
}
