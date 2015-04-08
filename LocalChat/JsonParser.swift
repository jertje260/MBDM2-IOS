//
//  JsonParser.swift
//  LocalChat
//
//  Created by User on 07/04/15.
//  Copyright (c) 2015 Jeroen Broekhuizen. All rights reserved.
//

import Foundation


class JsonParser {
    class var urlstart : String {return "http://192.168.2.5:3000"}
    
    class func login(username Username:String, password Password:String, callback: (AnyObject) ->()){
        var loginUser:User = User()
        var msg = ""
        let urlString = urlstart + "/users/login"
        let url :NSURL = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let params = "UserName=\(Username)&password=\(Password)"
        var err: NSError?
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        
        var task = session.dataTaskWithRequest(request, completionHandler:{data, response, error -> Void in

            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?

            if(strData != "Password incorrect" && strData != "User not found"){
                var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? NSDictionary

                if(err != nil) {
                    println(err!.localizedDescription)
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    msg = "Server might be having issues, could not handle your request"
                    callback(msg)
                }
                else {
                    if let parseJSON = json {
                        if let Username = parseJSON["UserName"] as? NSString {
                            if let Displayname = parseJSON["DisplayName"] as? NSString {
                                if let Radius = parseJSON["RadiusM"] as? NSInteger {
                                    if let ID = parseJSON["_id"] as? NSString {
                                        loginUser.ID = ID
                                        loginUser.userName = Username
                                        loginUser.displayName = Displayname
                                        loginUser.radius = Radius
                                        
                                        let preferences = NSUserDefaults.standardUserDefaults()
                                        
                                        preferences.setObject(loginUser.ID, forKey: "UserID")
                                        preferences.setObject(loginUser.userName, forKey: "Username")
                                        preferences.setObject(loginUser.displayName, forKey: "Displayname")
                                        preferences.setObject(loginUser.radius, forKey: "Radius")
                                        preferences.synchronize()
                                        
                                        callback(loginUser)
                                    }
                                }
                            }
                        }
                    }
                    else {
                        let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("Error could not parse JSON: \(jsonStr)")
                    }
                }
            } else {
                var msg = strData
                callback(msg!)
            }
        })
        
        task.resume()
        
    }
    
    class func getMessages() {
        let urlString = urlstart + "/lines"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!){(data, response, error) in
            println(NSString(data:data, encoding: NSUTF8StringEncoding))
        }
        
        task.resume()
    }
    
    class func getUser(username: String){
        let urlString = urlstart + "/users/\(username)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!){(data, response, error) in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?
            if(strData != ""){
                var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? NSDictionary
                
                if(err != nil) {
                    println(err!.localizedDescription)
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("error")

                }
                else {
                    if let parseJSON = json {
                        if let Username = parseJSON["UserName"] as? NSString {
                            if let Displayname = parseJSON["DisplayName"] as? NSString {
                                if let Radius = parseJSON["RadiusM"] as? NSInteger {
                                    if let ID = parseJSON["_id"] as? NSString {
                                        
                                        let preferences = NSUserDefaults.standardUserDefaults()
                                        preferences.setObject(ID, forKey: "UserID")
                                        preferences.setObject(Username, forKey: "Username")
                                        preferences.setObject(Displayname, forKey: "Displayname")
                                        preferences.setObject(Radius, forKey: "Radius")
                                        preferences.synchronize()
                                    }
                                }
                            }
                        }
                    }
                    else {
                        let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("Error could not parse JSON: \(jsonStr)")
                    }
                }
            } else {
                println("user doesn't exist")
            }

        }
        
        task.resume()
    }
    
    class func saveUser(user:User){
        let urlString = urlstart + "/users/\(user.userName!)"
        let url :NSURL = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let params = "UserName=\(user.userName!)&password=\(user.password!)&DisplayName=\(user.displayName!)&RadiusM=\(user.radius!)"
        var err: NSError?
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        
        var task = session.dataTaskWithRequest(request, completionHandler:{data, response, error -> Void in
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?
        })
        
        task.resume()
    }
    
    
}