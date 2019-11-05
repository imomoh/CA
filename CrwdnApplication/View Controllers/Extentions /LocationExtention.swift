//
//  LocationExtention.swift
//  CrwdnApplication
//
//  Created by Ebuka Egbunam on 10/29/19.
//  Copyright © 2019 Ebuka Egbunam. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        
        // guard let location = locations.last else { return }
        //        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        //        mapView.setRegion(region, animated: true)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
