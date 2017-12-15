//
//  RentalCollectionViewCell.swift
//  BicycleMap
//
//  Created by Seong ho Hong on 2017. 12. 11..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import UIKit

class RentalCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var rentalNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setInfo(rental: Rental) {
        rentalNameLabel.text = rental.name
    }
}
