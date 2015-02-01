//
//  TTSession.swift
//  TimeTuck_app
//
//  Created by Greenstein on 1/26/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import Foundation

public class TTSession {
    var key: String;
    var secret: String;

    public init(_ data: [String:String]) {
        key = data["key"]!;
        secret = data["secret"]!;
    }

    public init(key: String, secret: String) {
        self.key = key;
        self.secret = secret;
    }

    public func toDictionary() -> [String: String] {
        return ["key": key, "secret": secret];
    }
}