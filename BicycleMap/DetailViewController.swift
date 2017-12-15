//
//  DetailViewController.swift
//  BicycleMap
//
//  Created by DanBee on 2017. 12. 16..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeType: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var availableBike: UILabel!
    @IBOutlet weak var function: UILabel!
    @IBOutlet weak var workHour: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var callButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callButton.layer.cornerRadius = callButton.bounds.height/2

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textSet() {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
