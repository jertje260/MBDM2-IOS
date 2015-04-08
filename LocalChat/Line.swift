//
//  Line.swift
//  LocalChat
//
//  Created by Sam van Dijk on 27/03/15.
//  Copyright (c) 2015 Jeroen Broekhuizen. All rights reserved.
//

import Foundation

public class Line {
    
    var user:User
    var message:String
    var moment:NSDate?
    
    init(us:User, mes:String, mom:NSDate){
        user = us
        message = mes
        moment = mom
    }
    
    func Send(lat:Double, long:Double){
        
    }
    
    
}