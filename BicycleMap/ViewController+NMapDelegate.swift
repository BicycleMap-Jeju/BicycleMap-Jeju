//
//  ViewController+NMapDelegate.swift
//  BicycleMap
//
//  Created by Seong ho Hong on 2017. 12. 9..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import UIKit

extension ViewController: NMapViewDelegate {
    func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if (error == nil) { // success
            // set map center and level
            mapView.setMapCenter(NGeoPoint(longitude:126.52916660000005, latitude:33.3616666), atLevel:5)
            // set for retina display
            mapView.setMapEnlarged(true, mapHD: true)
            // set map mode : vector/satelite/hybrid
            mapView.mapViewMode = .vector
            mapView.mapViewBicycleMode = true
        } else { // fail
            print("onMapView:initHandler: \(error.description)")
        }
    }
    
    func addCircleAroundMyPosition() {
        if let mapOverlayManager = mapView?.mapOverlayManager {
            if let pathDataOverlay = mapOverlayManager.newPathDataOverlay(NMapPathData()) {
                
                if let circleData = NMapCircleData(capacity: 1) {
                    
                    circleData.initCircleData()
                    
                    if let location = myLocation {
                        circleData.addCirclePointLongitude(location.longitude, latitude: location.latitude, radius: 500.0)
                    }
                    circleData.end()
                    
                    circleArea = circleData
                    
                    // set circle style
                    if let circleStyle = NMapCircleStyle() {
                        
                        circleStyle.setLineType(.solid)
                        circleStyle.setFillColorWithRed(255/255, green: 173/255, blue: 39/255, alpha: 0.2)
                        circleStyle.strokeColor = UIColor.clear
                        circleStyle.strokeWidth = 1.0
                        circleData.circleStyle = circleStyle
                    }
                    circleArea = circleData
                    pathDataOverlay.add(circleData)
                }
            }
        }
    }
    
    func addMarker() {
        guard let centerList = self.centerList else { return }
        
        if let mapOverlayManager = mapView?.mapOverlayManager {
            
            if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {
                
                poiDataOverlay.initPOIdata(Int32(centerList.count))
                
                for (idx, center) in centerList.enumerated() {
                    let markerLocation = NGeoPoint(longitude: center._longitude, latitude: center._latitude)
                    var poiItem: NMapPOIitem?
                    
                    if let rental = center as? Rental {
                        switch rental.payType {
                        case "무료충전소":
                            poiItem = poiDataOverlay.addPOIitem(atLocation: markerLocation, title: center._name, type: UserPOIflagTypeDefault, iconIndex: Int32(idx), with: nil)
                        default:
                            poiItem = poiDataOverlay.addPOIitem(atLocation: markerLocation, title: center._name, type: UserPOIflagTypePay, iconIndex: Int32(idx), with: nil)
                        }
                    } else {
                        poiItem = poiDataOverlay.addPOIitem(atLocation: markerLocation, title: center._name, type: UserPOIflagTypeCertification, iconIndex: Int32(idx), with: nil)
                    }
                    
                    poiItem?.setPOIflagMode(.fixed)
                    poiItem?.hasRightCalloutAccessory = false
                }
                overlayItems = poiDataOverlay
                
                poiDataOverlay.endPOIdata()
                poiDataOverlay.selectPOIitem(at: 0, moveToCenter: true)
                poiDataOverlay.showAllPOIdata()
            }
        }
        
        if let currentLocation = myLocation {
            mapView?.setMapCenter(currentLocation, atLevel: 9)
        }
    }
    
    func clearOverlays() {
        if let mapOverlayManager = mapView?.mapOverlayManager {
            mapOverlayManager.clearOverlays()
        }
    }
}

extension ViewController: NMapPOIdataOverlayDelegate {
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        if selected {
            switch poiItem.poiFlagType {
            case UserPOIflagTypeDefault:
                poiItem.poiFlagType = UserPOIflagTypeSelected
                return #imageLiteral(resourceName: "free_center_click")
            case UserPOIflagTypeCertification:
                poiItem.poiFlagType = UserPOIflagTypeCertificationSelected
                return #imageLiteral(resourceName: "certification_center_click")
            case UserPOIflagTypePay:
                poiItem.poiFlagType = UserPOIflagTypePaySelected
                return #imageLiteral(resourceName: "pay_center_click")
            default: break
            }
        }

        return NMapViewResources.imageWithType(poiItem.poiFlagType, selected: selected)
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return NMapViewResources.anchorPoint(withType: poiFlagType)
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        return nil
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, didChangeSelectedPOIitemAt index: Int32, with object: Any!) -> Bool {
        if let prevIdx = prevIndex {
            if let poiItems = poiDataOverlay.poiData() as? [NMapPOIitem] {
                switch poiItems[Int(prevIdx)].poiFlagType {
                case UserPOIflagTypeSelected:
                    poiItems[Int(prevIdx)].poiFlagType = UserPOIflagTypeDefault
                case UserPOIflagTypeCertificationSelected:
                    poiItems[Int(prevIdx)].poiFlagType = UserPOIflagTypeCertification
                case UserPOIflagTypePaySelected:
                    poiItems[Int(prevIdx)].poiFlagType = UserPOIflagTypePay
                default: break
                    
                }
            }
            poiDataOverlay.updateImage(at: prevIdx)
        } else {
            prevIndex = index
        }
        poiDataOverlay.updateImage(at: index)
        prevIndex = index
        
        return true
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, viewForCalloutOverlayItem poiItem: NMapPOIitem!, calloutPosition: UnsafeMutablePointer<CGPoint>!) -> UIView! {
        // CollectionView 선택하기
        let indexPath = IndexPath(item: Int(poiItem.iconIndex), section: 0)
        rentalCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        rentalCollectionView.isHidden = false
        
        // 마커가 중앙에 오도록하기
        if mapView?.zoomLevel() != 9 {
            mapView?.setMapCenter(poiItem.location, atLevel: 9)
        } else {
            mapView?.animate(to: poiItem)
        }
        
        return nil
    }
}

extension ViewController: NMapLocationManagerDelegate {
    
    func locationManager(_ locationManager: NMapLocationManager!, didUpdateTo location: CLLocation!) {
        if !currentLocationFlag {
            let coordinate = location.coordinate
        
            let myLocation = NGeoPoint(longitude: coordinate.longitude, latitude: coordinate.latitude)
            let locationAccuracy = Float(location.horizontalAccuracy)
        
            mapView?.mapOverlayManager.setMyLocation(myLocation, locationAccuracy: locationAccuracy)
            mapView?.setMapCenter(myLocation, atLevel: 9)
            
            currentLocationFlag = true
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentLocation"),
                                            object: nil,
                                            userInfo: ["currentLocation": location.coordinate])
        }
    }
    
    func locationManager(_ locationManager: NMapLocationManager!, didFailWithError errorType: NMapLocationManagerErrorType) {
        var message: String = ""
        
        switch errorType {
        case .unknown: fallthrough
        case .canceled: fallthrough
        case .timeout:
            message = "일시적으로 내위치를 확인 할 수 없습니다."
        case .denied:
            message = "위치 정보를 확인 할 수 없습니다.\n사용자의 위치 정보를 확인하도록 허용하시려면 위치서비스를 켜십시오."
        case .unavailableArea:
            message = "현재 위치는 지도내에 표시할 수 없습니다."
        case .heading:
            message = "나침반 정보를 확인 할 수 없습니다."
        }
        
        if (!message.isEmpty) {
            let alert = UIAlertController(title:"NMapViewer", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style:.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        if let mapView = mapView, mapView.isAutoRotateEnabled {
            mapView.setAutoRotateEnabled(false, animate: true)
        }
    }
    
    func enableLocationUpdate() {
        
        if let locationManger = NMapLocationManager.getSharedInstance() {
            
            if locationManger.locationServiceEnabled() == false {
                locationManager(locationManger, didFailWithError: .denied)
                return
            }
            
            if locationManger.isUpdateLocationStarted() == false {
                // set delegate
                locationManger.setDelegate(self)
                // start updating location
                locationManger.startContinuousLocationInfo()
            }
        }
    }
    
    func disableLocationUpdate() {
        
        if let locationManager = NMapLocationManager.getSharedInstance() {
            
            if locationManager.isUpdateLocationStarted() {
                // start updating location
                locationManager.stopUpdateLocationInfo()
                // set delegate
                locationManager.setDelegate(nil)
            }
        }
        
        mapView?.mapOverlayManager.clearMyLocationOverlay()
    }
    
    func enableHeading() -> Bool {
        
        if let locationManager = NMapLocationManager.getSharedInstance() {
            
            let isAvailableCompass = locationManager.headingAvailable()
            
            if isAvailableCompass {
                
                mapView?.setAutoRotateEnabled(true, animate: true)
                
                locationManager.startUpdatingHeading()
            } else {
                return false
            }
        }
        
        return true;
    }
    
    func disableHeading() {
        if let locationManger = NMapLocationManager.getSharedInstance() {
            
            let isAvailableCompass = locationManger.headingAvailable()
            
            if isAvailableCompass {
                locationManger.stopUpdatingHeading()
            }
        }
        
        mapView?.setAutoRotateEnabled(false, animate: true)
    }
    
    func stopLocationUpdating() {
        disableHeading()
        disableLocationUpdate()
    }
}
