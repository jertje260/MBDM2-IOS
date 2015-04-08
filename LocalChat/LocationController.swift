//
//  LocationManager.swift
//  LocalChat
//
//  Created by Jeroen Broekhuizen on 22/03/15.
//  Copyright (c) 2015 Jeroen Broekhuizen. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController : NSObject, CLLocationManagerDelegate{
    var locationManager:CLLocationManager = CLLocationManager()
    
    override init(){
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
    }
}
