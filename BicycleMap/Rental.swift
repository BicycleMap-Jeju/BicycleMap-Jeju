//
//  Rental.swift
//  BicycleMap
//
//  Created by Seong ho Hong on 2017. 12. 10..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import Foundation

struct Rental: Center {
    internal var _name: String
    internal var _address: String
    internal var _latitude: Double
    internal var _longitude: Double
    private var _rentalType: String
    private var _start: String
    private var _end: String
    private var _closedDays: String
    private var _payType: PayType
    private var _charge: String?
    private var _airInjection: Bool
    private var _airInjectionType: String?
    private var _repairstand: Bool
    private var _managerNumber: String
    private var _manager: String
    private var _thumbUrl: String?
    
    
    enum PayType {
        case free
        case charge
    }
    
    init(name: String, rentalType: String, address: String, latitude: Double, longitude: Double, start: String, end: String, closedDays: String, payType: String, charge: String?, airInjection: Bool, airInjectionType: String?, repairstand: Bool, managerNumber: String, manager: String) {
        self._name = name
        self._rentalType = rentalType
        self._address = address
        self._latitude = latitude
        self._longitude = longitude
        self._start = start
        self._end = end
        self._closedDays = closedDays
        
        switch payType {
        case "무료":
            self._payType = .free
        default:
            self._payType = .charge
        }
        
        self._charge = charge
        self._airInjection = airInjection
        self._airInjectionType = airInjectionType
        self._repairstand = repairstand
        self._managerNumber = managerNumber
        self._manager = manager
    }
    
    init(name: String, rentalType: String, address: String, latitude: Double, longitude: Double, start: String, end: String, closedDays: String, payType: String, charge: String?, airInjection: Bool, airInjectionType: String?, repairstand: Bool, managerNumber: String, manager: String, thumbUrl: String) {
        self._name = name
        self._rentalType = rentalType
        self._address = address
        self._latitude = latitude
        self._longitude = longitude
        self._start = start
        self._end = end
        self._closedDays = closedDays
        
        switch payType {
        case "무료":
            self._payType = .free
        default:
            self._payType = .charge
        }
        
        self._charge = charge
        self._airInjection = airInjection
        self._airInjectionType = airInjectionType
        self._repairstand = repairstand
        self._managerNumber = managerNumber
        self._manager = manager
        self._thumbUrl = thumbUrl
    }
    
    public var name: String {
        get { return self._name }
    }
    
    public var rentalType: String {
        get { return self._rentalType }
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
    
    public var start: String {
        get { return self._start }
    }
    
    public var end: String {
        get { return self._end }
    }
    
    public var closedDays: String {
        get { return self._closedDays }
    }
    
    public var payType: String {
        get {
            switch _payType {
            case .free:
                return "무료충전소"
            default:
                return "유료충전소"
            }
        }
    }
}
