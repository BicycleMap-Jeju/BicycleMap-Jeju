//
//  RentalController.swift
//  BicycleMap
//
//  Created by Seong ho Hong on 2017. 12. 10..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import Foundation
import SwiftyJSON

class RentalController {
    var rentalList: [Rental] = []
    
    func getRental(info: String) -> [Rental] {
        guard let infoUrl = Bundle.main.url(forResource: info, withExtension: "json") else { return []}
        
        do {
            let data = try Data(contentsOf: infoUrl)
            guard let rentaInfolList = JSON(data).array else { return [] }
            
            for rental in rentaInfolList {
                let rentalInfo = Rental(name: rental["name"].description,
                                        rentalType: rental["rentalType"].description,
                                        address: rental["address"].description,
                                        latitude: rental["latitude"].doubleValue,
                                        longitude: rental["longitude"].doubleValue,
                                        start: rental["startTime"].description,
                                        end: rental["endTime"].description,
                                        closedDays: rental["closedDays"].description,
                                        payType: rental["payType"].description,
                                        charge: rental["charge"].string,
                                        airInjection: rental["airInjection"].boolValue,
                                        airInjectionType: rental["airInjectionType"].description,
                                        repairstand: rental["repairstand"].boolValue,
                                        managerNumber: rental["managerNumber"].description,
                                        manager: rental["manager"].description)
                
                rentalList.append(rentalInfo)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return rentalList
    }
}
