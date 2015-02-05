//
//  AppManager.swift
//  TimeTuck_app
//
//  Created by Greenstein on 1/28/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import Foundation


class TTAppManager {
    var user: TTUser?;
    var session: TTSession?;
    
    init() {
        
    }
    
    init(user: TTUser, session: TTSession) {
        self.user = user;
        self.session = session;
    }
    
    func isUserLoggedIn() -> Bool {
        return user != nil && session != nil;
    }
}