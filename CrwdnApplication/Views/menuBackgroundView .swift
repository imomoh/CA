//
//  menuBackgroundView .swift
//  CrwdnApplication
//
//  Created by Ebuka Egbunam on 12/1/19.
//  Copyright © 2019 Ebuka Egbunam. All rights reserved.
//

import UIKit

class menuBackroundView : UIView {
    
    
    
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = 5
        setupShadow()
        
        
    }
    
    func setupShadow(){
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
}
