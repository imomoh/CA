//
//  CollectionViewCell.swift
//  SlideCollection
//
//  Created by Ebuka Egbunam on 10/21/19.
//  Copyright © 2019 Ebuka Egbunam. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
         behindView.layer.cornerRadius = 12
        
        snapButtonOutlet.layer.shadowColor = UIColor.black.cgColor
        snapButtonOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        snapButtonOutlet.layer.masksToBounds = false
        snapButtonOutlet.layer.shadowRadius = 1.0
        snapButtonOutlet.layer.shadowOpacity = 0.5
        snapButtonOutlet.layer.cornerRadius = snapButtonOutlet.frame.width / 2
        snapButtonOutlet.backgroundColor = .red
        
//        behindView.layer.shadowColor = UIColor.black.cgColor
//        behindView.layer.shadowOpacity = 0.5
//        behindView.layer.shadowRadius = 5
//        behindView.layer.shadowOffset = CGSize(width: 15, height: 15)
//        behindView.clipsToBounds = true
//        behindView.layer.masksToBounds = true
//
        
        
        
        
        
        
        
    }
    
    
    @IBOutlet weak var snapButtonOutlet: UIButton!
    
    @IBOutlet weak var nameOfPlace: UILabel!
    @IBOutlet weak var coverFee: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var behindView: UIView!
    
    @IBOutlet weak var distanceInMiles: UILabel!
    
}
