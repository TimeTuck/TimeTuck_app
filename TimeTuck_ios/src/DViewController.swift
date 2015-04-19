//
//  DViewController.swift
//  TimeTuck
//
//  Created by Cole Scott on 3/12/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class DViewController: UIViewController, UITextFieldDelegate {
    var appManager: TTAppManager?;
    var capsule : TTTuck!;
 
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
   
    
    init(_ appManager: TTAppManager, tuck: TTTuck) {
        super.init(nibName: "DViewController", bundle: NSBundle.mainBundle());
        self.appManager = appManager
        self.capsule = tuck
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard");
        view.addGestureRecognizer(tap);
        comment.delegate = self;
        datePicker.backgroundColor = UIColor.whiteColor()
        let currentDate = NSDate()
        datePicker.minimumDate = currentDate
        datePicker.date = currentDate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func setDate(sender: UIButton) {
        
        capsule.setDate(datePicker.date)
        capsule.setComment(comment.text)
        let VC = AddFriendVC(appManager!, tuck: capsule)
        presentViewController(VC, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = count(textField.text) + count(string) - range.length
        return newLength <= 140 // Bool
    }
    
    func dismissKeyboard() {
        view.endEditing(true);
    }
    
    override func shouldAutorotate() -> Bool {
        return false;
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue);
    }
}