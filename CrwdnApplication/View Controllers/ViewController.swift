//
//  ViewController.swift
//  CrwdnApplication
//
//  Created by Ebuka Egbunam on 8/22/19.
//  Copyright © 2019 Ebuka Egbunam. All rights reserved.
//

class Crwds{
    
    
    var lattitude:  Double
    var longitude:Double
    var nameOfPlace:String = ""
    var distanceFromCurrentLocation : String = ""
    var imageID:String = ""
    var urlString = ""
    
    init(lattitude :Double, longitude : Double) {
        
        self.lattitude = lattitude
        self.longitude = longitude
    }
    
    
    func setCoordinate(){
        CLLocationCoordinate2DMake(self.lattitude, self.longitude)
        
    }
    
    func GetCoordinate() -> CLLocationCoordinate2D{
        
        return CLLocationCoordinate2DMake(self.lattitude, self.longitude)
    }
    
    
    func SetNameOfPlace(name : String)  {
        self.nameOfPlace = name
    }
    
    
    func getNameofPlace() -> String{
        return self.nameOfPlace
    }
    
    func setImageID(imageid:String){
        self.imageID = imageid
    }
    
    
    func getImageID() -> String{
        return self.imageID
    }
    
    
    func getURL() -> String {
        return self.urlString
    }
    
    func setURL(URL : String){
        self.urlString = URL
    }
    
    
    
}









import UIKit
import MapKit
import CoreLocation
import Parse

class ViewController: UIViewController , UIGestureRecognizerDelegate {
    
    
    
    
    enum cardState{
        case expanded
        case collapsed
    }
    
    
    //variables
    var chnagingImage:UIImage? = nil
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    let viewAnnotaionInMeters:Double = 675
    let  cellIdentifier = "realCell"
    var crowdList : [Crwds] = []
    let displayLimit = 20
    let cardTransformHeightWhenCollapsed  = -160
    let cardTransformHeightWhenExpanded = 30
    var cardViewController : CardViewController!
    var visualEffectView : UIVisualEffectView!
    let cardHeight :CGFloat = 285
    let cardhandleAreaHeight :CGFloat = 60
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
    
    
    @IBOutlet weak var animatedStack: UIStackView!
    
    
    @IBOutlet weak var topCrowds: UILabel!
    
    
    
    @IBOutlet weak var viewAdd: UIView!
    
    
    @IBOutlet weak var gestureView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var searchAndStatusView: UIView!
    
    @IBOutlet weak var positionOutlet: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var exampleImageView: UIImageView!
    
    @IBAction func centrePosition(_ sender: UIButton) {
        centerViewOnUserLocation()
        
    }
    
    
    //MARK:- handling views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupCollectionVew()
        //setupAnotations()
        setupGesture()
        setUpCard()
        checkLocationServices()
        searchAndStatusView.layer.borderColor = UIColor.red.cgColor
        searchAndStatusView.layer.cornerRadius = 15
        
        self.collectionView.register(UINib(nibName:"CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        let userLattidude = (locationManager.location?.coordinate.latitude)!
        let userLongitude = (locationManager.location?.coordinate.longitude)!
        populate(currentlattitude: userLattidude, currentLongitude: userLongitude)
        
//        let catPictureURL = "https://image.blockbusterbd.net/00416_main_image_04072019225805.png"
//        let catImage = DownloadImage(imageURL: catPictureURL)
//
//        exampleImageView.image = catImage
//
        
    }
    
    
    func setupAllAnotaions()
    {
        
        for coordinate in crowdList{
            let newCoordinate = coordinate.GetCoordinate()
            let anotation = MKPointAnnotation()
            anotation.coordinate = newCoordinate
            mapView.addAnnotation(anotation)
            
        }
        
        
    }
    
    func  ZoomToLocation( coordinate : CLLocationCoordinate2D)
    {
        //        let anotation = MKPointAnnotation()
        //        anotation.coordinate = coordinate
        //        mapView.addAnnotation(anotation)
        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: viewAnnotaionInMeters, longitudinalMeters: viewAnnotaionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func setupGesture(){
        let mygestureRecognizer = UIGestureRecognizer()
        mygestureRecognizer.delegate = self
        
        
    }
    
    
    
    func setupViewLook(){
        
        viewAdd.layer.cornerRadius = 20
        gestureView.layer.cornerRadius = 20
        gestureView.layer.shadowRadius = 1
        
        
        
        
    }
    
    
    func setupCollectionVew(){
        self.collectionView.register(UINib(nibName:"CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
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
            //print("yup")
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
    
    
    // parse services
    
    func populate(currentlattitude : Double , currentLongitude : Double){
        
        let parseGeoPoint = PFGeoPoint(latitude: currentlattitude, longitude: currentLongitude)
        let query = PFQuery(className: "Crowds")
        query.whereKey("location", nearGeoPoint: parseGeoPoint)
        query.limit = displayLimit
        query.findObjectsInBackground { (objects, error) in
            if objects != nil{
                // self.crowdList.removeAll()
                if error == nil  {
                    print("obects retrieved with grace")
                    
                    if objects!.count > 0 {
                        
                        for object in objects!{
                            let objectLocation = object.object(forKey: "location") as! PFGeoPoint
                            let objectLattiude = objectLocation.latitude
                            let objectLongitude = objectLocation.longitude
                            let objectLoctaionInCllocation = CLLocation(latitude: objectLattiude, longitude: objectLongitude)
                            
                            let userLocation = self.locationManager.location
                            
                            let distanceFromCurrentLocationInMiles = (userLocation?.distance(from: objectLoctaionInCllocation))! / 1609.344
                            
                            let objectNameOfPlace = object.object(forKey: "RadarName") as! String
                            let imageid = object.object(forKey: "PlaceID") as! String// string will be changed later
                            let singleItem = Crwds(lattitude: objectLattiude, longitude: objectLongitude)
                            singleItem.SetNameOfPlace(name: objectNameOfPlace)
                            singleItem.distanceFromCurrentLocation = "\(Int(distanceFromCurrentLocationInMiles)) m"
                            singleItem.setImageID(imageid: imageid)
                            // query image id here
                            
                            
                            
                            
                            
                            
                            // append item should be the last thing you do
                            self.crowdList.append(singleItem)
                            self.collectionView.reloadData()
                        }
                        self.setupAllAnotaions()
                    }
                    
                    
                    
                }
                    
                else{
                    print("the query failed")
                }
                
                
                
                
            }
            
            
        }
        
        
        
    }
    
    
    
    func queryImages(placeID :String , url: String) -> UIImage? {
        let finalImage: UIImage? = nil
        // do image query for one object here
        
        let query = PFQuery(className: "Images")
        query.whereKey("location", equalTo: placeID)
        // check image for pace id only
        query.findObjectsInBackground { (objects, error) in
            if let error = error{
                // Log details of the failure
                print(error.localizedDescription)
            }
            
            if let objects = objects{
                for object in objects{
                    if object.object(forKey: "location") as! String == placeID{
                        //check if image is a video or picture
                        
                        // get screenshot if its a video or get low quality picture
                    }
                    
                }
            }
            
            
        }
        
        
        
        
        //check if image is a video or picture
        
        // get screenshot if its a video or get low quality picture
        
        
        
        return finalImage
    }
    
    
    
    func DownloadImage(imageURL : String){
        /* this functions takes the image url as a string,
         conversts it to a url ,
         and then downloads it and save it in an optional variable
         */
        var finalImage:UIImage? = nil
        let url = URL(string: imageURL)!
        let session = URLSession(configuration: .default)
        let downloadPicTask = session.dataTask(with: url){ (data,response,error)  in
            if let e = error {
                // error downloading
                print("Error downloading cat picture: \(e)")
            }
                
            else{
                // no errors
                DispatchQueue.main.async {
                    // running things back on the main thread
                    if let imageData = data{
                        finalImage = UIImage(data: imageData)
                        self.chnagingImage = finalImage
                        
                    }else{
                        print("Couldn't get image: Image is nil")
                        
                    }
                    
                }
                
                
            }
            
        }
        downloadPicTask.resume()
        
        
    
        
    }
    
    func DownloadVideo(){
        
    }
    
    
    
}






















