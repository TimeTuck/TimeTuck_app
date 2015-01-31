//
//  LoginTextFields.swift
//  TimeTuck_app
//
//  Created by Greenstein on 1/29/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class LoginTextFields: UITextField {
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0);
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0);
    }
}
