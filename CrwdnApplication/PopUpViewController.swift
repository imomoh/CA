//
//  PopUpViewController.swift
//  CrwdnApplication
//
//  Created by Ebuka Egbunam on 8/22/19.
//  Copyright © 2019 Ebuka Egbunam. All rights reserved.
//

import UIKit
import CoreLocation

class PopUpViewController: UIViewController ,  CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    var key = "complete"
   // let controller = viewcont

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func accessToLocation(_ sender: UIButton) {
        if sender.tag == 1 || sender.tag == 3{
         //controller.locationManager.requestWhenInUseAuthorization()
           UserDefaults.standard.set(key, forKey: "buttonPressed")
        }
        else{
            UserDefaults.standard.set(nil, forKey: "buttonPressed")
        }
        
    }
    
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
