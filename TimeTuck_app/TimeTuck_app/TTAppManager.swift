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
    
    class func checkUser() -> TTAppManager? {
        var userInfo = NSUserDefaults();
        var appManager: TTAppManager?;
        var found = false;
        var storedSession: AnyObject? = userInfo.objectForKey("session");
        if storedSession != nil {
            var access = TTDataAccess();
            var foundSession = TTSession(storedSession! as [String: String]);
            access.checkUser(foundSession) {
                user, session in
                if (user != nil && session != nil) {
                    appManager = TTAppManager(user: user!, session: session!);
                    appManager?.saveSession();
                } else {
                    userInfo.removeObjectForKey("session");
                }
                found = true;
            }
            while(!found) {}
            return appManager;
        } else {
            return nil;
        }
    }

    init() {
        
    }
    
    init(user: TTUser, session: TTSession) {
        self.user = user;
        self.session = session;
    }
    
    func isUserLoggedIn() -> Bool {
        return user != nil && session != nil;
    }
    
    func saveSession() {
        var userInfo = NSUserDefaults();
        userInfo.setObject(session?.toDictionary(), forKey: "session");
        userInfo.synchronize();
    }
}