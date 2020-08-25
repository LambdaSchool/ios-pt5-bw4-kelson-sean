//
//  MapViewController.swift
//  PrivateYelp
//
//  Created by Sean Acres on 8/19/20.
//  Copyright © 2020 Sean Kelson. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var myReviewsButton: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let locationManager = CLLocationManager()
    var mostRecentPlacemark: CLPlacemark? {
        didSet {
            if (restaurants.count > 0) {
                self.mapView.addAnnotations(restaurants)
            }
        }
    }
    
    var restaurants: [Restaurant] = []
    
    var restaurantBeingPassed: Restaurant?
    var user: User?
    var controller = ModelController()
    var googlePlaceController = GooglePlaceController()
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        loadAllRestaurants()
        
        if restaurants.count > 0 {
            loadAllRestaurants()
            self.mapView.addAnnotations(restaurants)
        } else if user != nil && restaurants.count < 1 {
            loadAllRestaurants()
            self.mapView.addAnnotations(restaurants)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (!appDelegate.hasAlreadyLaunched) {
            presentAlertAndCreateUser()
        } else {
            loadAndAssignUser()
            loadAllRestaurants()
        }
        
        mapView.userLocation.title = nil
        mapView.showsUserLocation = false
        setUpViews()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ReviewView")
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - Private Functions
    
    private func presentAlertAndCreateUser() {
        
        if (!appDelegate.hasAlreadyLaunched) {
            appDelegate.setHasAlreadyLaunched()
            let alertController = UIAlertController(title: "Welcome to curator", message: "please enter your name below", preferredStyle: .alert)
            let continueButton = UIAlertAction(title: "Continue", style: .default) { (action) in
                let usersNameTextField = alertController.textFields![0]
                
                self.user = self.controller.oneTimeCreateUser(name: usersNameTextField.text ?? "")
                usersNameTextField.endEditing(true)
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Enter your name here"
                textField.textColor = .black
            }
            alertController.addAction(continueButton)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func setUpViews() {
        myReviewsButton.layer.shadowColor = UIColor.black.cgColor
        myReviewsButton.layer.shadowOpacity = 0.25
        myReviewsButton.layer.shadowRadius = 5
        myReviewsButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        myReviewsButton.layer.masksToBounds = false
    }
    
    func loadAndAssignUser() {
        let request : NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let arrayOfUserReturned = try CoreDataStack.shared.mainContext.fetch(request)
            user = arrayOfUserReturned[0]
            print(user?.reviews?.count)
            print(user?.reviews)
        } catch {
            print("Error loading reviews")
        }
    }
    
    func loadAllRestaurants() {
        let request : NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        
        do {
            restaurants = try CoreDataStack.shared.mainContext.fetch(request)
            print("Restaurants: \(restaurants.count)")
        } catch {
            print("Error loading Restaurants")
        }
    }
    
    func deleteAllRecords() {
        let context = CoreDataStack.shared.mainContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Review")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    @IBAction func createNewReviewTapped(_ sender: UIButton) {
        guard let mostRecentPlacemark = mostRecentPlacemark,
            let address = mostRecentPlacemark.name,
            let latitude = mostRecentPlacemark.location?.coordinate.latitude,
            let longitude = mostRecentPlacemark.location?.coordinate.longitude
            else { return }
        
        let latitudeString = String(Double(latitude))
        let longitudeString = String(Double(longitude))
        
        googlePlaceController.getNearbyPlace(latitude: latitudeString, longitude: longitudeString) { (places, error) in
            if let error = error {
                NSLog("Error getting google place details: \(error)")
                return
            }
            
            guard let places = places else { return }
            
            if places.count >= 2 {
                let restaurantName = places[1].name
                let address = places[1].vicinity
                
                let newRestaurant = Restaurant(address: address, cusineType: "", latitude: String(Double(latitude)), longitude: String(Double(longitude)), name: restaurantName)
                self.restaurantBeingPassed = newRestaurant
                self.performSegue(withIdentifier: "AddReviewSegue", sender: self)
            }
        }
        
//        let alertController = UIAlertController(title: "To add a new review", message: "Please enter restaurant name below", preferredStyle: .alert)
//        let continueButton = UIAlertAction(title: "Continue", style: .default) { (action) in
//            let restaurantNameTextField = alertController.textFields![0]
//
//            if restaurantNameTextField.text != "" {
//                let newRestaurant = Restaurant(address: address, cusineType: "", latitude: String(Double(latitude)), longitude: String(Double(longitude)), name: restaurantNameTextField.text ?? "")
//                restaurantNameTextField.endEditing(true)
//                self.restaurantBeingPassed = newRestaurant
//                self.performSegue(withIdentifier: "AddReviewSegue", sender: self)
//            }
//        }
//        alertController.addTextField { (textField) in
//            textField.placeholder = "Enter Restaurant Name Here..."
//            textField.textColor = .black
//        }
//        alertController.addAction(continueButton)
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(alertController, animated: true, completion: nil)
    }
}


//MARK: - CLLocationManagerDelegate
extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        NSLog("location: \(location)")
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                NSLog("error with geocoder: \(error)")
            }
            
            if let placemark = placemarks?.first {
                self.mostRecentPlacemark = placemark
                NSLog("Name of placemark: \(placemark.name ?? "")")
            }
        }
        let latitude = String(Double(location.coordinate.latitude))
        let longitude = String(Double(location.coordinate.longitude))
        googlePlaceController.getNearbyPlace(latitude: latitude, longitude: longitude) { (places, error) in
            NSLog("Place name: \(places?[1].name)")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("location error: \(error)")
    }
}

//MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
         let button = UIButton(type: .detailDisclosure)
               
               var marker: MKMarkerAnnotationView?
               
               loadAllRestaurants()
               guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ReviewView") as? MKMarkerAnnotationView else {
                   fatalError("Incorrect Identifier")
               }
               
               annotationView.canShowCallout = true
               annotationView.isEnabled = true
               annotationView.rightCalloutAccessoryView = button
               
               
               marker = annotationView
               
               return marker
        
    }
    
       func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            let restaurant = view.annotation as! Restaurant
            let placeName = restaurant.name
            let placeInfo = restaurant.address
            
            let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .default))
            ac.addAction(UIAlertAction(title: "Open in maps", style: .default, handler: { (alert) in
                guard let restaurantLatitude = restaurant.latitude else { return }
                guard let restaurantLongitude = restaurant.longitude else { return }
                let newLatitude = restaurantLatitude as NSString
                let newlatitudeValue = newLatitude.doubleValue
                let newLongitude = restaurantLongitude as NSString
                let newLongitudeValue = newLongitude.doubleValue
                
                let coordinate = CLLocationCoordinate2D(latitude: newlatitudeValue, longitude: newLongitudeValue)
                let placeMark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placeMark)
                mapItem.name = restaurant.name ?? "Restaurant name unknown"
                mapItem.openInMaps(launchOptions: nil)
                
            }))
            present(ac, animated: true)
        }
    }

extension MapViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddReviewSegue" {
            let destinationVC = segue.destination as? ReviewRatingChecklistViewController
            destinationVC?.restaurant = self.restaurantBeingPassed
            destinationVC?.controller = self.controller
            destinationVC?.user = self.user
        } else if segue.identifier == "MyReviewsSegue" {
            let destinationVC = segue.destination as? MyReviewsViewController
            destinationVC?.user = self.user
            destinationVC?.controller = self.controller
        }
    }
}

