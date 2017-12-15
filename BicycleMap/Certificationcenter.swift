//
//  Certificationcenter.swift
//  BicycleMap
//
//  Created by Seong ho Hong on 2017. 12. 15..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import Foundation

struct Certificationcenter: Center {
    internal var _name: String
    internal var _address: String
    internal var _latitude: Double
    internal var _longitude: Double
    
    init(name: String, address: String, latitude: Double, longitude: Double) {
        self._name = name
        self._address = address
        self._latitude = latitude
        self._longitude = longitude
    }
    
    public var name: String {
        get { return self._name }
    }
    
    public var address: String {
        get { return self._address }
    }
    
    public var latitude: Double {
        get { return self._latitude }
    }
    
    public var longitude: Double {
        get { return self._longitude }
    }
}
