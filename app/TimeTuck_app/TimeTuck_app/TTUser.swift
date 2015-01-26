//
//  TTUser.swift
//  TimeTuck_app
//
//  Created by Greenstein on 1/25/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import Foundation

public class TTUser {
    var id : Int;
    var username : String;
    var email : String;
    var phone : String;
    var activated : Bool;
    var active : Bool;
    
    public init(id : Int, username : String, email : String , phone : String, activated : Bool, active : Bool) {
        self.id = id;
        self.username = username;
        self.email = email;
        self.activated = activated;
        self.phone = phone;
        self.active = active;
    }
}