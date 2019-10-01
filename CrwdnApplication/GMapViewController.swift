//
//  GMapViewController.swift
//  CrwdnApplication
//
//  Created by Ebuka Egbunam on 9/30/19.
//  Copyright © 2019 Ebuka Egbunam. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation


class GMapViewController: UIViewController {
    // setting up slide view
    
    
    enum CardState {
        case expanded
        case collapsed
    }
    var GMapViewNibController : GMapNibViewController!
    var visualEffectView: UIVisualEffectView!
    let cardHeight:CGFloat = 600
    let cardHandleAreaHeight:CGFloat = 65
    var cardVisible = false
    var nexstate:CardState{
        return cardVisible ? .collapsed : .expanded
    }
    
    var runingAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted :CGFloat = 0
    
    
    // setting up location
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // location and map
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        placesClient = GMSPlacesClient.shared()
        
        
        
        
        let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!,
                                              longitude: (locationManager.location?.coordinate.longitude)!,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //mapView.isMyLocationEnabled = true

        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true

    
        
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        view = mapView
//
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        
        // slide up animation
        
        setupCard()




        
    }
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []

    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    
    func listLikelyPlaces() {
      // Clean up from previous sessions.
      likelyPlaces.removeAll()

      placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
        if let error = error {
          // TODO: Handle the error.
          print("Current Place error: \(error.localizedDescription)")
          return
        }

        // Get likely places and add to the list.
        if let likelihoodList = placeLikelihoods {
          for likelihood in likelihoodList.likelihoods {
            let place = likelihood.place
            self.likelyPlaces.append(place)
          }
        }
      })
    }
    


    

}

extension GMapViewController: CLLocationManagerDelegate {

  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")

    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                          longitude: location.coordinate.longitude,
                                          zoom: zoomLevel)

    if mapView.isHidden {
      mapView.isHidden = false
      mapView.camera = camera
    } else {
      mapView.animate(to: camera)
    }

    listLikelyPlaces()
  }

  // Handle authorization for the location manager.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .restricted:
      print("Location access was restricted.")
    case .denied:
      print("User denied access to location.")
      // Display the map using the default location.
      mapView.isHidden = false
    case .notDetermined:
      print("Location status not determined.")
    case .authorizedAlways: fallthrough
    case .authorizedWhenInUse:
      print("Location status is OK.")
    @unknown default:
        fatalError()
    }
  }

  // Handle location manager errors.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    print("Error: \(error)")
  }
}

extension GMapViewController{
    
    func setupCard(){
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        
        GMapViewNibController = GMapNibViewController(nibName: "GMapNibViewController", bundle: nil)
        //GMapNibViewController = GMapNibViewController(nibName:"GMapNibViewController" , bundle: nil)
        self.addChild(GMapViewNibController)
        self.view.addSubview(GMapViewNibController.view)
        GMapViewNibController.view.frame = CGRect(
            x: 0,
            y: self.view.frame.height - cardHandleAreaHeight,
            width: self.view.bounds.width ,
            height:cardHeight)
        
        GMapViewNibController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        
        GMapViewNibController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        GMapViewNibController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
        
        
    }
    @objc
    func handleCardTap(recognizer:UITapGestureRecognizer){
        
        
    }
    @objc
    func handleCardPan(recognizer : UIPanGestureRecognizer){
        
        switch recognizer.state {
        case .began:
            // start transition
            break
        case .changed:
            //update our transition
            break
        case .ended:
            // continuetransition
            break
        default:
            break
        }
        
    }
   
    
    
}
