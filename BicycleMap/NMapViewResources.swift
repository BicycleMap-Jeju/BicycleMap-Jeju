//
//  NMapViewResources.swift
//  BicycleMap
//
//  Created by Seong ho Hong on 2017. 12. 9..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import UIKit

// set custom POI Flag Type.
// NMapPOIflagTypeReserved 보다 큰 값으로 설정.
let UserPOIflagTypeDefault: NMapPOIflagType = NMapPOIflagTypeReserved + 1
let UserPOIflagTypeInvisible: NMapPOIflagType = NMapPOIflagTypeReserved + 2
let UserPOIflagTypeSelected: NMapPOIflagType = NMapPOIflagTypeReserved + 3
let UserPOIflagTypeCertification: NMapPOIflagType = NMapPOIflagTypeReserved + 4
let UserPOIflagTypeCertificationSelected: NMapPOIflagType = NMapPOIflagTypeReserved + 5
let UserPOIflagTypePay: NMapPOIflagType = NMapPOIflagTypeReserved + 6
let UserPOIflagTypePaySelected: NMapPOIflagType = NMapPOIflagTypeReserved + 7

class NMapViewResources: NSObject {
    
    open static func imageWithType(_ poiFlagType: NMapPOIflagType, selected: Bool) -> UIImage? {
        switch poiFlagType {
        case NMapPOIflagTypeLocation:
            return #imageLiteral(resourceName: "current_location")
        case NMapPOIflagTypeLocationOff:
            return #imageLiteral(resourceName: "current_location")
        case NMapPOIflagTypeCompass:
            return #imageLiteral(resourceName: "ic_angle")
        case UserPOIflagTypeDefault:
            return #imageLiteral(resourceName: "free_center")
        case UserPOIflagTypeInvisible:
            return #imageLiteral(resourceName: "1px_dot")
        case UserPOIflagTypeSelected:
            return #imageLiteral(resourceName: "free_center_click")
        case UserPOIflagTypeCertification:
            return #imageLiteral(resourceName: "certification_center")
        case UserPOIflagTypeCertificationSelected:
            return #imageLiteral(resourceName: "certification_center_click")
        case UserPOIflagTypePay:
            return #imageLiteral(resourceName: "pay_center")
        case UserPOIflagTypePaySelected:
            return #imageLiteral(resourceName: "pay_center_click")
        default:
            return nil
        }
    }
    
    open static func anchorPoint(withType type: NMapPOIflagType) -> CGPoint {
        switch type {
        case NMapPOIflagTypeLocation: fallthrough
        case NMapPOIflagTypeLocationOff: fallthrough
        case NMapPOIflagTypeCompass:
            return CGPoint(x: 0.5, y: 0.5)
        case UserPOIflagTypeDefault:
            return CGPoint(x: 0.5, y: 1.0)
        case UserPOIflagTypeInvisible:
            return CGPoint(x: 0.5, y: 0.5)
        default:
            return CGPoint(x: 0.5, y: 0.5)
        }
    }
}

