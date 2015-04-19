//
//  TTTuck.swift
//  TimeTuck
//
//  Created by Cole Scott on 4/2/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import Foundation
import UIKit

public class TTTuck {
    var comment: String?;
    var date: NSDate?;
    var picture: UIImage?;
    var shareusers: [Int];
    
    public init () {
        self.shareusers = [Int]()
    }
    
    public func setPic (picture: UIImage) {
        self.picture = picture
    }
    
    public func setDate (date: NSDate) {
        self.date = date
    }
    
    public func setComment (comment: String) {
        self.comment = comment
    }
    
    public func addUsers (id: Int) {
        shareusers.append(id)
    }
}