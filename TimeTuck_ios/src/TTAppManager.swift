//
//  AppManager.swift
//  TimeTuck_app
//
//  Created by Greenstein on 1/28/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import Foundation
import UIKit

class TTAppManager {
    var shouldAutoRotate = false;
    
    var deviceToken: String?
    var mainTabNav: MainNavigationTabBarController?
    var session: TTSession?;
    var user: TTUser?;

    class func checkUser() -> TTAppManager? {
        var userInfo = NSUserDefaults();
        var appManager: TTAppManager?;
        var found = false;
        var storedSession: AnyObject? = userInfo.objectForKey("session");
        if storedSession != nil {
            var access = TTDataAccess();
            var foundSession = TTSession(storedSession! as! [String: String]);
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
                access.updateDeviceToken(session!, deviceToken: strippedToken2, complete: nil);
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
    
    func setBadget(key: String, value: Int) {
        switch (key) {
            case "friend_accept":
                mainTabNav?.friends?.tabBarItem.badgeValue = value.description;
                mainTabNav?.friends?.reloadContent();
                break;
            case "friend_request":
                mainTabNav?.friends?.tabBarItem.badgeValue = value.description;
                mainTabNav?.friends?.reloadContent();
                break;
            case "new_timetuck":
                mainTabNav?.feed?.tabBarItem.badgeValue = value.description
                break;
            default:
                break;
        }
    }
    
    func removeBadge(key: String) {
        var amount: Int?;
        var type: String?;
        switch (key) {
            case "friend_all":    // Any friend notification is stored in one place.
                amount = mainTabNav?.friends?.tabBarItem.badgeValue?.toInt();
                if (amount != nil) {
                    mainTabNav?.friends?.tabBarItem.badgeValue = nil;
                    type = "friend_request,friend_accept";
                }
                break;
            case "new_timetuck":
                 amount = mainTabNav?.feed?.tabBarItem.badgeValue?.toInt();
                 if (amount != nil) {
                    mainTabNav?.feed?.tabBarItem.badgeValue = nil;
                    type = key;
                 }
                break;
            default:
                break;
        }
        
        if (amount != nil) {
            var access = TTDataAccess();
            access.notificationUpdate(session!, type: type!) {
                values in
                UIApplication.sharedApplication().applicationIconBadgeNumber -= amount!
                self.updateInnerBadge();
            }
        }
    }
    
    func updateInnerBadge() {
        NSOperationQueue.mainQueue().addOperationWithBlock() {
            if UIApplication.sharedApplication().applicationIconBadgeNumber == 0 {
                self.mainTabNav?.notifications?.tabBarItem.badgeValue = nil;
            } else {
                self.mainTabNav?.notifications?.tabBarItem.badgeValue = UIApplication.sharedApplication().applicationIconBadgeNumber.description;
            }
        }
    }
    
    func refreshBadges() {
        var access = TTDataAccess();
        if self.session != nil {
            access.notificationGet(self.session!) {
                value in
                NSOperationQueue.mainQueue().addOperationWithBlock() {
                    var amount: Int = 0;
                    if value.count != 0 {
                        for v in value {
                            amount += (v["amount"] as! Int);
                            self.setBadget(v["type"] as! String, value: v["amount"] as! Int);
                        }
                    }
                    UIApplication.sharedApplication().applicationIconBadgeNumber = amount;
                    self.updateInnerBadge();
                }
            }
        }

    }
}