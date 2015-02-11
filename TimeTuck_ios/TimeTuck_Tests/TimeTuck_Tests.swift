//
//  TimeTuck_appTests.swift
//  TimeTuck_appTests
//
//  Created by Greenstein on 1/25/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit
import Foundation
import XCTest
import TimeTuck

class TimeTuck_appTests: XCTestCase {

    var sess: TTSession?;
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoginCheckLogout() {
        var shouldLoop = true;
        var access = TTDataAccess();
        access.loginUser("admgrn12", password: "123456", completed:{ user, session in
            self.sess = session;
            XCTAssertNotNil(user, "User login Failed");
            XCTAssertNotNil(session, "Session login Failed");
            shouldLoop = false;
        });

        while(shouldLoop) {}

        shouldLoop = true;

        if (self.sess != nil) {
            access.checkUser(self.sess!, completed: {
                user, session in
                self.sess = session;
                XCTAssertNotNil(user, "User Check Failed For Session");
                XCTAssertNotNil(session, "User Check Failed For User");
                shouldLoop = false;
            });
        } else {
            XCTAssertNotEqual(true, true, "No Session created, Cannot Check User");
            shouldLoop = false;
        }

        while(shouldLoop) {}

        shouldLoop = true;
        var worked = false;

        if (sess != nil) {
            access.logoutUser(sess!,
                completed:{ successful in
                    if (successful) {
                        worked = true;
                        shouldLoop = false;
                    } else {
                         shouldLoop = false;
                    }
                });
        } else {
            XCTAssertNotEqual(true, true, "No Session created, Cannot logout");
            return;
        }

        while (shouldLoop) {}
        XCTAssertEqual(worked, true, "Cannot log user out");
    }
    
    func testRegistration() {
        var shouldLoop = true;
        var worked = false;
        var access = TTDataAccess();
        
        access.registerUser("admgrn12", password: "132456", phoneNumber: "561-445-9699", email: "admgrn@comcast.net",
            success:{user, session in
                shouldLoop = false;
            }, failureDuplicateInfo: {username, email, phoneNumber in
                worked = true;
                shouldLoop = false;
            }, failureIncorrectInfo: {username, email, phoneNumber in
                shouldLoop = false;
        });

        while (shouldLoop) {}
        XCTAssertEqual(worked, true, "Registration Error");
    }
}
