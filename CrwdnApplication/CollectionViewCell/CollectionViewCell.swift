//
//  CollectionViewCell.swift
//  SlideCollection
//
//  Created by Ebuka Egbunam on 10/21/19.
//  Copyright © 2019 Ebuka Egbunam. All rights reserved.
//

import UIKit
import  CoreLocation
import MapKit

class CollectionViewCell: UICollectionViewCell {
    
    let firstView = ViewController()
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    let coordinate =  CLLocationCoordinate2DMake(38.8977, -77.0365)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
         behindView.layer.cornerRadius = 12
        
//        snapButtonOutlet.layer.shadowColor = UIColor.black.cgColor
//        snapButtonOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        snapButtonOutlet.layer.masksToBounds = false
//        snapButtonOutlet.layer.shadowRadius = 1.0
//        snapButtonOutlet.layer.shadowOpacity = 0.5
//        snapButtonOutlet.layer.cornerRadius = snapButtonOutlet.frame.width / 2
//        snapButtonOutlet.layer.borderWidth = 1
//
//
//        snapButtonOutlet.layer.borderColor = UIColor.red.cgColor
//        snapButtonOutlet.backgroundColor = UIColor.gray
//        snapButtonOutlet.imageView?.layer.cornerRadius = (snapButtonOutlet.imageView?.frame.width)! / 2
//        snapButtonOutlet.imageView?.contentMode = .scaleAspectFit
        
        //snapButtonOutlet.backgroundColor = .red
        
//        behindView.layer.shadowColor = UIColor.black.cgColor
//        behindView.layer.shadowOpacity = 0.5
//        behindView.layer.shadowRadius = 5
//        behindView.layer.shadowOffset = CGSize(width: 15, height: 15)
//        behindView.clipsToBounds = true
//        behindView.layer.masksToBounds = true
//
        
        snapImage.layer.cornerRadius =  snapImage.frame.width / 2
        snapImage.clipsToBounds = true 
        
        
        
        
        
        
    }
    
    
    @IBOutlet weak var snapButtonOutlet: UIButton!
    
    @IBOutlet weak var nameOfPlace: UILabel!
    @IBOutlet weak var coverFee: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var behindView: UIView!
    
    @IBOutlet weak var snapImage: UIImageView!
    @IBOutlet weak var distanceInMiles: UILabel!
    
    
    
    
    
    
    @IBAction func changeLoationViewButton(_ sender: Any) {
        
       
        
    }
    
    
    
    
    
    
    
}



