//
//  TTWebViews.swift
//  TimeTuck
//
//  Created by Greenstein on 3/15/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import Foundation

public class TTWebViews {
    var endpoint: String!
    
    public init() {
        if let path = NSBundle.mainBundle().pathForResource("settings", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) {
                endpoint = dict["WebURL"] as? String
            }
        }
    }
    
    public func GetMainFeedRequest(session: TTSession) -> NSURLRequest {
        var request = buildHTTPRequest("/", bodyData: session.toDictionary());
        return request;
    }
    
    func buildHTTPRequest(url: String, bodyData data: [String: AnyObject]?) -> NSURLRequest {
        var query = "";
        var i = 0;
        if data != nil {
            for (key, value) in data! {
                if i == 0 {
                    query = "?\(key)=\(value)";
                } else {
                    query += "&\(key)=\(value)"
                }
                ++i;
            }
        }
        
        var request = NSMutableURLRequest(URL: NSURL(string: getPath(url + query))!);
        request.HTTPMethod = "GET";
        return request;
    }
    
    func getPath(url: String) -> String {
        return endpoint + url;
    }
}
