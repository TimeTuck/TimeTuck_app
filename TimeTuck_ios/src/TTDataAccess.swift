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
    
    public func loginUser(username: String, password : String, deviceToken: String?, completed:(user: TTUser?,
                session: TTSession?) -> Void) {
        var login = ["username": username, "password": password];
                    
        if deviceToken != nil {
            login["device_token"] = deviceToken!;
        }
                    
        makeHTTPRequest("/login", bodyData: login, requestMethod: "POST") {
            response, data, error in
            if (response != nil && (response as! NSHTTPURLResponse).statusCode == 200) {
                let values = self.JSONParseDictionary(data);
                if ((values["status"] as! Int) == 0) {
                    let user = TTUser(values["user"] as! [String: AnyObject]);
                    let session = TTSession(values["session"] as! [String: String]);
                    completed(user: user, session: session);
                } else {
                    completed(user: nil, session: nil);
                }
            }
        }
    }
    
    public func registerUser(username: String, password: String, phoneNumber: String, email: String, deviceToken: String?,
                             success: (user: TTUser?, session: TTSession?) -> Void,
                             failureDuplicateInfo: (username: Bool, email: Bool, phoneNumber: Bool) -> Void,
                             failureIncorrectInfo: (username: String?, email: String?, phoneNumber: String?) -> Void) {
        var register = ["username": username, "password": password, "phone_number": phoneNumber, "email": email];
        if deviceToken != nil {
            register["device_token"] = deviceToken;
        }
        
        makeHTTPRequest("/register", bodyData: register, requestMethod: "POST") {
            response, data, error in
            if (response != nil && (response as! NSHTTPURLResponse).statusCode == 200) {
                let values = self.JSONParseDictionary(data);
                if ((values["status"] as! Int) == 0) {
                    let user = TTUser(values["user"] as! [String: AnyObject]);
                    let session = TTSession(values["session"] as! [String: String]);
                    success(user: user, session: session);
                } else if ((values["status"] as! Int) == 1) {
                    let error = values["errors"] as! [String: Bool];
                    failureDuplicateInfo(username: error["username"]!, email: error["email"]!, phoneNumber: error["phonenumber"]!);
                } else {
                    let error = values["errors"] as! [String: String];
                    failureIncorrectInfo(username: error["username"], email: error["email"], phoneNumber: error["phone_number"]);
                }
            }
        }
    }

    public func checkUser(session: TTSession, completed: (user: TTUser?, session: TTSession?, deviceToken: String?) -> Void) {
        makeHTTPRequest("/check_user", bodyData: ["session": session.toDictionary()] , requestMethod: "POST") {
            response, data, error in
            if (response != nil && (response as! NSHTTPURLResponse).statusCode == 200) {
                let values = self.JSONParseDictionary(data);
                let user = TTUser(values["user"] as! [String: AnyObject]);
                let session = TTSession(values["session"] as! [String: String]);
                let token = values["device_token"] as! String?;
                completed(user: user, session: session, deviceToken: token);
            } else {
                completed(user: nil, session: nil, deviceToken: nil);
            }
        };
    }
    
    public func updateDeviceToken(session: TTSession, deviceToken: String?, complete: (() -> Void)?) {
        var data: [String: AnyObject] = ["session": session.toDictionary()];
        if deviceToken != nil {
            data["device_token"] = deviceToken;
        }
        makeHTTPRequest("/update_device_token", bodyData: data, requestMethod: "POST") {
            response, data, error in
            if complete != nil {
                complete!();
            }
        }
    }

    public func logoutUser(session: TTSession, completed: (successful: Bool) -> Void) {
        makeHTTPRequest("/logout", bodyData: ["session": session.toDictionary()] , requestMethod: "POST") {
            response, data, error in
            if (response != nil && (response as! NSHTTPURLResponse).statusCode == 200) {
                let values = self.JSONParseDictionary(data);
                if ((values["status"] as! Int) == 0) {
                    completed(successful: true);
                    return;
                }
            }
            completed(successful: false);
        };
    }
    
    public func sendFriendRequest(session: TTSession, requestedFriend: Int, completed: (status: Int?) -> Void) {
        makeHTTPRequest("/send_friend_request/" + String(requestedFriend), bodyData: ["session": session.toDictionary()] , requestMethod: "POST") {
            response, data, error in
            if (response != nil && (response as! NSHTTPURLResponse).statusCode == 200) {
                let values = self.JSONParseDictionary(data);
                completed(status: values["status"] as? Int);
            } else {
                completed(status: nil);
            }
        };
    }
    
    public func notificationUpdate(session: TTSession, type: String, completed: (values: [[String: AnyObject]]) -> Void) {
        var body: [String: AnyObject] = ["session": session.toDictionary()];
        body["type"] = type;
        makeHTTPRequest("/notification_update", bodyData: body, requestMethod: "POST") {
            response, data, error in
            if (response != nil && (response as NSHTTPURLResponse).statusCode == 200) {
                let values = self.JSONParseDictionary(data);
                completed(values: values["values"] as [[String: AnyObject]]);
            } else {
                completed(values: []);
            }
        };
    }
    
    public func searchUsers(session: TTSession, search: String, completed: (users: [[String: AnyObject]]) -> Void) {
        var params = session.toDictionary();
        params["search"] = search;
        var sessData = urlFromDict(params);
        makeHTTPRequest("/search_users" + sessData, bodyData: nil, requestMethod: "GET") {
            response, data, error in
            if (response != nil && (response as! NSHTTPURLResponse).statusCode == 200) {
                let values = self.JSONParseDictionary(data);
                completed(users: values["users"] as! [[String: AnyObject]]);
            } else {
                completed(users: []);
            }
        };
    }
    
    public func respondFriendRequest(session: TTSession, respondedFriend: Int, accept: Bool, completed: (status: Int?) -> Void) {
        makeHTTPRequest("/respond_friend_request/" + String(respondedFriend), bodyData: ["session": session.toDictionary(), "accept": accept] , requestMethod: "POST") {
            response, data, error in
            if (response != nil && (response as! NSHTTPURLResponse).statusCode == 200) {
                let values = self.JSONParseDictionary(data);
                completed(status: values["status"] as? Int);
            } else {
                completed(status: nil);
            }
        };
    }
    
    public func getFriends(session: TTSession, completed: (friends: [[String: AnyObject]], requests: [[String: AnyObject]]) -> Void) {
        var sessData = urlFromDict(session.toDictionary());
        makeHTTPRequest("/get_friends" + sessData, bodyData: nil, requestMethod: "GET") {
          response, data, error in
            if (response != nil && (response as! NSHTTPURLResponse).statusCode == 200) {
                let values = self.JSONParseDictionary(data);
                completed(friends: values["friends"] as! [[String: AnyObject]], requests: values["requests"] as! [[String: AnyObject]]);
            } else {
                completed(friends: [], requests: []);
            }
        };
    }
    
    func upload_image(session: TTSession, imageData: NSData?, untuckDate: NSDate, users: [Int], complete: () -> Void) {
        var dictData = session.toDictionary();
        var dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
        dictData["uncapsule_date"] = dateFormatter.stringFromDate(untuckDate);
        dictData["friends"] = users.description;
        makeImageRequest("/image_upload", bodyData: dictData, imageData: imageData,
            imageName: "image" + NSDate().timeIntervalSince1970.description + ".png") {
                response, data, error in
                if (response != nil && (response as! NSHTTPURLResponse).statusCode == 200) {
                    complete();
                }
        }
    }
    
    func makeImageRequest(url: String, bodyData data: [String: AnyObject]?, imageData: NSData?, imageName: String,
                          completionHandler complete: (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void) {
        let goToUrl = NSURL(string: getPath(url));
        let request = NSMutableURLRequest(URL: goToUrl!);
        let queue = NSOperationQueue();
        let boundary = "------------abiu2132iu1dfuho1h89234hfflkadsf";
        let contentType = "multipart/form-data; boundary=" + boundary;
        let body = NSMutableData();
                            
        request.HTTPMethod = "POST";
        request.setValue(contentType, forHTTPHeaderField: "Content-Type");
        request.setValue("application/json", forHTTPHeaderField: "Accept");
                            
        for (key, value) in data! {
            body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!);
            body.appendData(NSString(format: "Content-Disposition: form-data; name=\"\(key)\"\n\n\(value)").dataUsingEncoding(NSUTF8StringEncoding)!);
        }
        
        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!);
        body.appendData(NSString(format: "Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\n\n", imageName).dataUsingEncoding(NSUTF8StringEncoding)!);
        body.appendData(imageData!);
        body.appendData(NSString(format: "\r\n--%@--\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!);
            request.HTTPBody = body;
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: complete);
    }
    
    func makeHTTPRequest(url: String, bodyData data: [String: AnyObject]?, requestMethod method : String,
                         completionHandler complete: (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void) {
        let url = NSURL(string: getPath(url));
        let request = NSMutableURLRequest(URL: url!);
        let queue = NSOperationQueue();
        if data != nil {
            let jsonBody = jsonify(data!);
            request.HTTPBody = jsonBody;
        }
        request.HTTPMethod = method;
        request.setValue("application/json", forHTTPHeaderField: "Content-Type");
        request.setValue("application/json", forHTTPHeaderField: "Accept");
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: complete);
    }
    
    func urlFromDict(dict: [String: String]) -> String {
        if (dict.count > 0) {
            var output: String = "?";
            var i = 0;
            for (key, value) in dict {
                if (i++ > 0) {
                    output += "&";
                }
                output += key.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
                       + "=" + value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!;
            }
            return output;
        } else {
            return "";
        }
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