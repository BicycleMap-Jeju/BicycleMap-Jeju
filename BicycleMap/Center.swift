//
//  Center.swift
//  BicycleMap
//
//  Created by Seong ho Hong on 2017. 12. 15..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import Foundation

protocol Center {
    var _name: String { get }
    var _address: String { get }
    var _latitude: Double { get }
    var _longitude: Double { get }
}
