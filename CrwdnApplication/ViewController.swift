//
//  ViewController.swift
//  CrwdnApplication
//
//  Created by Ebuka Egbunam on 8/22/19.
//  Copyright © 2019 Ebuka Egbunam. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // removes navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    // added delegate using storyboard method
    override func viewDidLoad() {
        super.viewDidLoad()
        //mapView.delegate = self as? MKMapViewDelegate
        checkLocationServices()
        // Do any additional setup after loading the view.
    }
    
    // everything thing that has to do witj the pop up slide view 
    
    
    
    
    
    
    
    
    
    
    
    
    // everything to do with location and map set up
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func presentPopUp () {
        let popUpSb = UIStoryboard(name: "Main", bundle: nil)
        let popUp = popUpSb.instantiateViewController(withIdentifier: "locationPopUp")
        present(popUp, animated: true ,completion: nil)
        
        
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapStuff()
            
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            //presentPopUp()
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            
            
            break
        @unknown default:
            //fatal error
            break
        }
    }
    
    
    func mapStuff(){
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
    }
    
    
    
    
    
}

extension ViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
        // do something
    }
    
    
}

