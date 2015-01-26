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
import TimeTuck_app

class TimeTuck_appTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin() {
        var access = TTDataAccess();
        XCTAssertNotNil(access.loginUser("admgrn12", password: "123456"), "Login not working");
    }
}
