//
//  JsonParser.swift
//  LocalChat
//
//  Created by User on 07/04/15.
//  Copyright (c) 2015 Jeroen Broekhuizen. All rights reserved.
//

import Foundation

extension NSDate {
    
    public class func dateFromISOString(string: String) -> NSDate {
        var dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter.dateFromString(string)!
    }
}

class JsonParser {
    class var urlstart : String {return "http://localchat-api.herokuapp.com"}
    
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
                        if let Username = parseJSON["UserName"] as? String {
                            if let Displayname = parseJSON["DisplayName"] as? String {
                                if let Radius = parseJSON["RadiusM"] as? Int {
                                    if let ID = parseJSON["_id"] as? String {
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
    
    class func getMessages(latitude: Double, longitude: Double, callback: (AnyObject) -> ()) {
        if let radius = NSUserDefaults.standardUserDefaults().stringForKey("Radius") {
            let urlString = urlstart + "/lines?Latitude=\(latitude)&Longitude=\(longitude)&Radius=\(radius)"
            let url = NSURL(string: urlString)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!){(data, response, error) in
                
                var returnMessages = Array<Line>()
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &err) as? NSArray
                
                if(err != nil){
                    println(err!.localizedDescription)
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("error")
                } else {
                    
                    if let messages = json {
                        for i in 0..<messages.count {
                            if let m = messages[i] as? NSDictionary{
                                if let body = m["Body"] as? String {
                                    if let latitude = m["Latitude"] as? Double {
                                        if let longitude = m["Longitude"] as? Double {
                                            if let mom = m["Datetime"] as? String {
                                                if let u = m["User"] as? NSDictionary {
                                                    if let un = u["UserName"] as? String {
                                                        if let dn = u["DisplayName"] as? String {
                                                            var date : NSDate? = NSDate.dateFromISOString(mom)
                                                            var aLine = Line(us: User(name: un, dname: dn) , mes: body, mom: date!, lat: latitude, lon: longitude)
                                                            returnMessages.append(aLine)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                callback(returnMessages.reverse())
            }
            
            task.resume()
        }
    }
    
    class func getUser(username: String, callback: (String) ->()){
        let urlString = urlstart + "/users/\(username)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!){(data, response, error) in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?
            var msg = ""
            if(strData != ""){
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
                                        
                                        let preferences = NSUserDefaults.standardUserDefaults()
                                        preferences.setObject(ID, forKey: "UserID")
                                        preferences.setObject(Username, forKey: "Username")
                                        preferences.setObject(Displayname, forKey: "Displayname")
                                        preferences.setObject(Radius, forKey: "Radius")
                                        preferences.synchronize()
                                        msg = "User set"
                                        sleep(3)
                                        callback(msg)
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
    
    class func addUser(username: String, password: String, callback: (AnyObject) ->()){
        let urlString = urlstart + "/users"
        let url :NSURL = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let params = "UserName=\(username)&password=\(password)"
        var err: NSError?
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        var msg = ""
        var loginUser = User()
        var task = session.dataTaskWithRequest(request, completionHandler:{data, response, error -> Void in
            
        var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
        var err: NSError?
        
            var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? NSDictionary
            
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                msg = "This username is already in use."
                callback(msg)
            }
            else {
                if let parseJSON = json {
                    if let Username = parseJSON["UserName"] as? String {
                        if let Displayname = parseJSON["DisplayName"] as? String {
                            if let Radius = parseJSON["RadiusM"] as? Int {
                                if let ID = parseJSON["_id"] as? String {
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
        })
        
        task.resume()
    }
    
    class func sendMessage(msg: String, latitude: Double, longitude: Double, callback: (String) ->()){
        let urlString = urlstart + "/lines"
        let url :NSURL = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let Userid = NSUserDefaults.standardUserDefaults().stringForKey("UserID")!
        
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let params = "User=\(Userid)&Body=\(msg)&Latitude=\(latitude)&Longitude=\(longitude)"
        var err: NSError?
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        var returnMsg = ""
        
        var task = session.dataTaskWithRequest(request, completionHandler:{data, response, error -> Void in
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?
            
            var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? NSDictionary
            
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                returnMsg = "Something went wrong"
                callback(returnMsg)
            }
            else {
                if let parseJSON = json {

                    if let ID = parseJSON["_id"] as? String {
                        returnMsg = "success"
                        callback(returnMsg)
                    }
                }
                else {
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
    }

    
    
}