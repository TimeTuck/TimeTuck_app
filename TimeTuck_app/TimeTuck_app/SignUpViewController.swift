//
//  SignUpViewController.swift
//  TimeTuck_app
//
//  Created by Greenstein on 1/29/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    var appManager: TTAppManager?;
    
    @IBOutlet weak var username: LoginTextFields!
    @IBOutlet weak var usernameHeight: NSLayoutConstraint!
    
    @IBOutlet weak var phoneNumber: LoginTextFields!
    @IBOutlet weak var phoneNumberHeight: NSLayoutConstraint!
    
    @IBOutlet weak var email: LoginTextFields!
    @IBOutlet weak var emailHeight: NSLayoutConstraint!
    
    @IBOutlet weak var password: LoginTextFields!
    @IBOutlet weak var passwordHeight: NSLayoutConstraint!
    
    @IBOutlet weak var verifyPassword: LoginTextFields!
    @IBOutlet weak var verifyPasswordHeight: NSLayoutConstraint!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    var visibleHeight : CGFloat?
    var offset: CGFloat?
    
    init(_ appManager: TTAppManager) {
        super.init(nibName: "SignUpViewController", bundle: NSBundle.mainBundle());
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil);
        
        username.delegate = self;
        email.delegate = self;
        phoneNumber.delegate = self;
        password.delegate = self;
        verifyPassword.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true);
    }
    
    @IBAction func notEditingItem(sender: LoginTextFields) {
        var toUpdate = getHeight(sender);
        view.layoutIfNeeded();
        
        UIView.animateWithDuration(0.2){
            toUpdate!.constant = 30;
            self.view.layoutIfNeeded();
        }
    }

    @IBAction func editingItem(sender: LoginTextFields) {

        var toUpdate = getHeight(sender);
        view.layoutIfNeeded();
        
        UIView.animateWithDuration(0.2){
            toUpdate!.constant = 50;
            self.view.layoutIfNeeded();
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func register(sender: UIButton) {
        var access = TTDataAccess();
        errorMessage.numberOfLines = 1;
        view.endEditing(true);
        
        if (username.text == "" || email.text == "" || phoneNumber.text == "" || password.text == "" ||
            verifyPassword == "") {
                errorMessage.text = "Please enter all info";
                return;
        }
        
        if (password.text != verifyPassword.text) {
            errorMessage.text = "Password verification doesn't match.";
        } else {
            access.registerUser(username.text,
                                password: password.text,
                                phoneNumber: phoneNumber.text,
                                email: email.text,
                                success: registerSuccess,
                                failureDuplicateInfo: registerFailDup,
                                failureIncorrectInfo: registerIncorrectInfo);
        }
    }
    
    func registerSuccess(user: TTUser?, session: TTSession?) {
        NSOperationQueue.mainQueue().addOperationWithBlock() {
            self.errorMessage.text = "Registered!";
        }
    }
    
    func registerFailDup(username: Bool, email: Bool, phoneNumber: Bool) {
        var count = 0;
        var message: String = "";
        
        if username {
            message = "Username";
            ++count;
        }
        if email {
            ++count;
        }
        if phoneNumber {
            ++count;
        }
        
        if email {
            if (message == "") {
                message = "Email";
            } else {
                if (count == 2) {
                    message += " and email";
                } else {
                    message += ", email";
                }
            }
        }
        
        if phoneNumber {
            if (message == "") {
                message = "Phone number";
            } else {
                if (count == 2) {
                    message += " and phone number";
                } else {
                    message += ", and phone number";
                }
            }
        }
        
        if count > 1 {
            message += " are already taken.";
        } else {
            message += " is already taken."
        }
        
        NSOperationQueue.mainQueue().addOperationWithBlock() {
            self.errorMessage.text = message;
        }
    }
    
    func registerIncorrectInfo(username: String?, email: String?, phoneNumber: String?) {
        var message: String = "";
        var count = 0;
        
        if username != nil {
            message = username!;
            ++count;
        }
        if email != nil {
            if count > 0 {
                message += "\n ";
            }
            message += email!;
            ++count;
        }
        if phoneNumber != nil {
            if count > 0 {
                message += "\n";
            }
            message += phoneNumber!;
            ++count;
        }
        
        NSOperationQueue.mainQueue().addOperationWithBlock() {
            self.errorMessage.numberOfLines = count;
            self.errorMessage.text = message;
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var height = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() as CGRect!;
        visibleHeight = UIScreen.mainScreen().bounds.height - height.size.height;
        for item in view.subviews {
            if item.isFirstResponder() {
                updateTextFieldPosition(item as UITextField);
                break;
            }
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
    
    func keyboardWillHide() {
        offset = 0;
        visibleHeight = nil;
        UIView.animateWithDuration(0.2) {
            self.view.frame.origin.y = 0;
        }
    }
    
    func getHeight(field: LoginTextFields) -> NSLayoutConstraint? {
        switch(field) {
        case username:
            return self.usernameHeight;
        case phoneNumber:
            return self.phoneNumberHeight;
        case email:
            return self.emailHeight;
        case password:
            return self.passwordHeight;
        case verifyPassword:
            return self.verifyPasswordHeight;
        default:
            return nil;
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return false;
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait;
    }
}