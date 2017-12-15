//
//  ViewController.swift
//  BicycleMap
//
//  Created by Seong ho Hong on 2017. 12. 9..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var rentalCollectionView: UICollectionView!
    
    var mapView: NMapView?
    var overlayItems: NMapPOIdataOverlay?
    var changeStateButton: UIButton?
    var currentLocationFlag = false
    var rentalList: [Rental]?
    var prevOffset: CGPoint?
    var prevIndex: Int32?

    
    let rentalController = RentalController()
    
    enum state {
        case disabled
        case tracking
    }
    
    var currentState: state = .disabled
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        rentalCollectionView.dataSource = self
        rentalCollectionView.delegate = self
        mapView = NMapView(frame: self.view.frame)
        
        if let mapView = mapView {
            // set the delegate for map view
            mapView.delegate = self
            // set the application api key for Open MapViewer Library
            mapView.setClientId("M9LPmVTupRcfEnoNau_W")
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(mapView)
            
            changeStateButton = createButton()
            
            if let button = changeStateButton {
                mapView.addSubview(button)
            }
        }
        
        view.addSubview(rentalCollectionView)
        rentalCollectionView.register(UINib(nibName: "RentalCollectionViewCell", bundle: nil) , forCellWithReuseIdentifier: "rentalCell")
        setCollectionViewLayou()
        
        rentalList = rentalController.getRental(info: "JejuRentalInfo")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView?.viewDidAppear()
        
        addMarker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createButton() -> UIButton? {
        
        let button = UIButton(type: .custom)
        
        button.frame = CGRect(x: 15, y: 80, width: 36, height: 36)
        button.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_normal"), for: .normal)
        
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc func buttonClicked(_ sender: UIButton!) {
        switch currentState {
        case .disabled:
            enableLocationUpdate()
            updateState(.tracking)
        case .tracking:
            stopLocationUpdating()
            updateState(.disabled)
            currentLocationFlag = false
        }
    }
    
    func updateState(_ newState: state) {
        
        currentState = newState
        
        switch currentState {
        case .disabled:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_normal"), for: .normal)
        case .tracking:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_selected"), for: .normal)
        }
    }
    
    func setCollectionViewLayou() {
        let layout = RentalCollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        layout.itemSize = CGSize(width: self.view.bounds.width - 64 - 10, height: 120)
        rentalCollectionView.collectionViewLayout = layout
        
        rentalCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
}

