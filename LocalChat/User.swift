//
//  User.swift
//  LocalChat
//
//  Created by Sam van Dijk on 27/03/15.
//  Copyright (c) 2015 Jeroen Broekhuizen. All rights reserved.
//

import Foundation

public class User {
    var ID: String?
    var userName: String?
    var displayName: String?
    var radius:Int?
    var password:String?
    
    init(){
        
    }
    
    init(name:String, dname:String){
        userName = name
        displayName = dname
    }
    
}
