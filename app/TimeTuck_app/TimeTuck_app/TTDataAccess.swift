//
//  TTDataAccess.swift
//  TimeTuck_app
//
//  Created by Greenstein on 1/25/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import Foundation

public class TTDataAccess {
    var endpoint : String?;
    
    public init() {
        if let path = NSBundle.mainBundle().pathForResource("settings", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) {
                endpoint = dict["ServiceURL"] as? String
            }
        }
    }
    
    public func loginUser(username: String, password : String, completed:(user: TTUser?, session: TTSession?) -> Void) -> Void {
        let login = ["username": username, "password": password];
        makeHTTPRequest("/login", bodyData: login, requestMethod: "POST", completionHandler:{ response, data, error in
            if ((response as NSHTTPURLResponse).statusCode == 200) {
                let values = self.JSONParseDictionary(data);
                if ((values["status"] as Int) == 0) {
                    let user = TTUser(values["user"] as [String: AnyObject]);
                    let session = TTSession(values["session"] as [String: String]);
                    completed(user: user, session: session);
                }
                completed(user: nil, session: nil);
            }
        });
    }
    
    /* public func registerUser(username: String, password: String, phoneNumber: String, email: String, success:
        (user: TTUser?, session: TTSession?) -> Void, failure: (username: Bool, email: Bool, phoneNumber: Bool) -> Void) -> Void {
            let register = ["username": username, "password": password, "phone_number": phoneNumber, "email": email];
            makeHTTPRequest("/register", bodyData: register, requestMethod: "POST", completionHandler:{ response, data, error in
                if ((response as NSHTTPURLResponse).statusCode == 200) {
                    let values = self.JSONParseDictionary(data);
                    if ((values["status"] as Int) == 0) {
                        let user = TTUser(values["user"] as [String: AnyObject]);
                        let session = TTSession(values["session"] as [String: String]);
                        completed(user: user, session: session);
                    }
                    completed(user: nil, session: nil);
                }
            });
        
    } */
    
    func makeHTTPRequest(url: String, bodyData data: [String: AnyObject], requestMethod method : String, completionHandler complete: (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void) {
        let url = NSURL(string: getPath(url));
        let request = NSMutableURLRequest(URL: url!);
        let queue = NSOperationQueue();
        let jsonBody = jsonify(data);

        request.HTTPBody = jsonBody;
        request.HTTPMethod = method;
        request.setValue("application/json", forHTTPHeaderField: "Content-Type");
        request.setValue("application/json", forHTTPHeaderField: "Accept");
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: complete);
    }
    
    func getPath(path : String) -> String {
        return endpoint! + path;
    }
    
    func jsonify (dictionary: AnyObject) -> NSData! {
        if let data = NSJSONSerialization.dataWithJSONObject(dictionary, options: nil, error: nil) {
            return data;
        }
        return nil;
    }
    
    func JSONParseDictionary(jsonData: NSData) -> [String: AnyObject] {
        if let dictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions(0), error: nil)  as? [String: AnyObject] {
            return dictionary
        }
        return [String: AnyObject]()
    }
}
