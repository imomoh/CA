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
    
    // MARK:- variables,enums closures to do with cardview
    //enum
    enum cardState{
        case expanded
        case collapsed
    }
    
    //variables
    var cardViewController : CardViewController!
    var visualEffectView : UIVisualEffectView!
    let cardHeight :CGFloat = 300
    let cardhandleAreaHeight :CGFloat = 90
    var cardVisible = false
    var nextState :cardState{
        return cardVisible ? .collapsed : .expanded
    }
    let cornerRadius : CGFloat = 10
    let timeInterval = 0.9
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    
    // end of varibels and etc
    
    
    @IBOutlet weak var animatedLabel: UIButton!
    
    
    @IBOutlet weak var positionOutlet: UIButton!
    
    @IBAction func centrePosition(_ sender: UIButton) {
        centerViewOnUserLocation()
        
    }
    
    
    //MARK:- handling views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mapView.delegate = self as? MKMapViewDelegate
        checkLocationServices()
        
        setUpCard()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // everything to do with location and map set up
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    //MARK:- LOCATION SETTINGS
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            print("yup")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            fatalError()
        }
    }
    
    
    // end oflocation services

    
    
    
}

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

// everything thing that has to do witj the pop up slide view 

extension ViewController{
    
    
    func setUpCard(){
        //visualEffectView = UIVisualEffectView()
        //visualEffectView.frame = self.view.frame
        //self.view.addSubview(visualEffectView)
        
        cardViewController = CardViewController(nibName: "CardViewController", bundle: nil)
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardhandleAreaHeight,
                                               width: self.view.bounds.width, height: cardhandleAreaHeight)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(recogonizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(recognizer:)))
        
        cardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        cardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
        
        
        
    }
    @objc
    func handleTap(recogonizer : UITapGestureRecognizer){
        switch recogonizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
            
            
            
            
        default:
            break
        }
        
    }
    @objc
    func handlePan(recognizer : UIPanGestureRecognizer){
        switch recognizer.state {
        case .began:
            startTrans(state: nextState, duration: timeInterval)
        case .changed:
            let translation = recognizer.translation(in: self.cardViewController.handleArea)
            var fractionCompleted = translation.y  / cardHeight
            fractionCompleted = cardVisible ? fractionCompleted : -fractionCompleted
            updateTrans(fractionCompleted: fractionCompleted)
            
        case .ended:
            continuetrans()
        default:
            break
        }
        
    }
    
    
    func animateTransitionIfNeeded( state : cardState , duration :TimeInterval){
        if runningAnimations.isEmpty{
            // animting frame
            let frameAnimator  = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                
                switch state{
                case .expanded:
                    self.cardViewController.view.frame.origin.y =
                        self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height
                        - self.cardhandleAreaHeight
                
                }
                
            }
            frameAnimator.addCompletion { (_) in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
//            //animate conner radius
//            let connerRadius = UIViewPropertyAnimator(duration: duration, curve: .linear) {
//                switch state{
//                case .collapsed:
//                    self.cardViewController.view.layer.cornerRadius = 0
//                case .expanded:
//                    self.cardViewController.view.layer.cornerRadius = 0
//                    
//                }
//            }
//            
//            connerRadius.startAnimation()
//            runningAnimations.append(connerRadius)
//            
            // animate button/label
            let buttonAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio:1) {
                switch state{
                case .collapsed:
                    self.animatedLabel.transform = CGAffineTransform(translationX: 0, y: -(self.animatedLabel.frame.height - 64))

                case .expanded:
                    self.animatedLabel.transform = CGAffineTransform(translationX: 0, y: -(self.cardHeight - self.animatedLabel.frame.height + 9))

                }
            }

            buttonAnimator.startAnimation()
            runningAnimations.append(buttonAnimator)

            //buttonanimator ended
            
            let positionButtonAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio:1) {
                switch state{
                case .collapsed:
                    self.positionOutlet.transform = CGAffineTransform(translationX: 0, y: -(self.positionOutlet.frame.height - 64))

                case .expanded:
                    self.positionOutlet.transform = CGAffineTransform(translationX: 0, y: -(self.cardHeight - self.positionOutlet.frame.height + 9))

                }
            }

            positionButtonAnimator.startAnimation()
            runningAnimations.append(positionButtonAnimator)

            
            
        }
        
    }
    
    func startTrans(state : cardState , duration : TimeInterval){
        if runningAnimations.isEmpty{
            animateTransitionIfNeeded(state: state, duration: duration)
            
        }
        for animator in runningAnimations{
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete + animationProgressWhenInterrupted
        }
        
        
    }
    
    func updateTrans(fractionCompleted : CGFloat){
        
        for animator in runningAnimations{
            animator.fractionComplete = fractionCompleted
        }
        
    }
    
    func continuetrans (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
        
    }
}



