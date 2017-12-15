//
//  CenterController.swift
//  BicycleMap
//
//  Created by Seong ho Hong on 2017. 12. 15..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import Foundation
import SwiftyJSON

class CenterController {
    var centerList: [Center] = []
    
    init() {
        setRental(info: "JejuRentalInfo")
        setCrawler(info: "CrawlerRentalInfo")
        setCertificationcenter(info: "CertificateCenterInfo")
    }
    
    private func setCertificationcenter(info: String) {
        guard let infoUrl = Bundle.main.url(forResource: info, withExtension: "json") else { return }
        
        do {
            let data = try Data(contentsOf: infoUrl)
            guard let certificationcenterInfoList = JSON(data).array else { return }
            
            for certificationcenter in certificationcenterInfoList {
                let certificationcenterInfo = Certificationcenter(name: certificationcenter["name"].description,
                                                                  address: certificationcenter["address"].description,
                                                                  latitude: certificationcenter["latitude"].doubleValue,
                                                                  longitude: certificationcenter["longitude"].doubleValue)
                
                centerList.append(certificationcenterInfo)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setRental(info: String) {
        guard let infoUrl = Bundle.main.url(forResource: info, withExtension: "json") else { return }
        
        do {
            let data = try Data(contentsOf: infoUrl)
            guard let rentaInfolList = JSON(data).array else { return }
            
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
                
                centerList.append(rentalInfo)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setCrawler(info: String) {
        guard let infoUrl = Bundle.main.url(forResource: info, withExtension: "json") else { return }
        
        do {
            let data = try Data(contentsOf: infoUrl)
            guard let rentaInfolList = JSON(data).array else { return }
            
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
                                        manager: rental["manager"].description,
                                        thumbUrl: rental["thumbUrl"].description)
                
                centerList.append(rentalInfo)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getCenterList() -> [Center] {
        return centerList
    }
}
