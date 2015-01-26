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
    
    public func loginUser(username: String, password : String) -> TTUser? {
        let path = getPath("/login");
        let url = NSURL(string: path);
        let request = NSMutableURLRequest(URL: url!);
        let login = ["username": username, "password": password];
        let jsonBody = jsonify(login);
        
        request.HTTPMethod = "POST";
        request.HTTPBody = jsonBody;
        request.setValue("application/json", forHTTPHeaderField: "Content-Type");
        request.setValue("application/json", forHTTPHeaderField: "Accept");

        var response : NSURLResponse? = nil;

        if let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) {
            let values = JSONParseDictionary(data);
            if (response as NSHTTPURLResponse!).statusCode == 200 {
                if ((values["status"] as Int) == 0) {
                    var u = values["user"] as [String: AnyObject];
                    return TTUser(id: u["id"] as Int, username: u["username"] as String, email: u["email"] as String,
                            phone: u["phone_number"] as String, activated: u["activated"] as Bool,
                            active: u["active"] as Bool);
                }
            }
        }
        
        return nil;
        
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
