//
//  TTUser.swift
//  TimeTuck_app
//
//  Created by Greenstein on 1/25/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import Foundation

public class TTUser {
    var activated : Bool;
    var active : Bool;
    var email : String;
    var id : Int;
    var phone : String;
    var username : String;
    
    public init(_ data : [String: AnyObject]) {
        activated = data["activated"] as! Bool;
        active = data["active"] as! Bool;
        email = data["email"] as! String;
        id = data["id"] as! Int;
        phone = data["phone_number"] as! String;
        username = data["username"] as! String;
    }
    
    public init(id : Int, username : String, email : String , phone : String, activated : Bool, active : Bool) {
        self.activated = activated;
        self.active = active;
        self.email = email;
        self.id = id;
        self.phone = phone;
        self.username = username;
    }
}