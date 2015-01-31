//
//  SignUpViewController.swift
//  TimeTuck_app
//
//  Created by Greenstein on 1/29/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
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
}
