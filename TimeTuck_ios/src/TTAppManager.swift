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
    var shouldAutoRotate = false;
    var deviceToken: String?
    
    class func checkUser() -> TTAppManager? {
        var userInfo = NSUserDefaults();
        var appManager: TTAppManager?;
        var found = false;
        var storedSession: AnyObject? = userInfo.objectForKey("session");
        if storedSession != nil {
            var access = TTDataAccess();
            var foundSession = TTSession(storedSession! as [String: String]);
            access.checkUser(foundSession) {
                user, session, token in
                if (user != nil && session != nil) {
                    appManager = TTAppManager(user: user!, session: session!);
                    appManager?.deviceToken = token;                            // Store token.
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
    
    func updateDeviceToken(token: String?) {
        var strippedToken1 = deviceToken?.stringByReplacingOccurrencesOfString(" ", withString: "")
                                         .stringByReplacingOccurrencesOfString(">", withString: "")
                                         .stringByReplacingOccurrencesOfString("<", withString: "");
        var strippedToken2 = token?.stringByReplacingOccurrencesOfString(" ", withString: "")
                                   .stringByReplacingOccurrencesOfString(">", withString: "")
                                   .stringByReplacingOccurrencesOfString("<", withString: "");
        
        if (self.session != nil && self.user != nil) {
            if ((deviceToken == nil && token != nil) ||
                (deviceToken != nil && token != nil && strippedToken1 != strippedToken2) ||
                (deviceToken != nil && token == nil)) {
                // Token's do not match, must update token
                self.deviceToken = token;
                var access = TTDataAccess();
                access.updateDeviceToken(session!, deviceToken: deviceToken, complete: nil);
            }
        } else {
            // User does not have a session, do not update token, just store it
            self.deviceToken = token;
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return user != nil && session != nil;
    }
    
    func saveSession() {
        var userInfo = NSUserDefaults();
        userInfo.setObject(session?.toDictionary(), forKey: "session");
        userInfo.synchronize();
    }
    
    func clearSession() {
        var userInfo = NSUserDefaults();
        userInfo.removeObjectForKey("session");
        userInfo.synchronize();
        session = nil;
        user = nil;
    }
    
    func getUserID() -> Int {
        
        return user!.id
        
    }
}