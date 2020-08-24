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
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.oneTimeCreateUser(name: "Bob Test")
        loadAndAssignUser()
        loadAllRestaurants()
//        deleteAllRecords()
        setUpViews()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ReviewView")
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - Private Functions
    
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
    
//    func deleteAllRecords() {
//        let context = CoreDataStack.shared.mainContext
//        
//        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Review")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
//
//        do {
//            try context.execute(deleteRequest)
//            try context.save()
//        } catch {
//            print ("There was an error")
//        }
//    }
    
    @IBAction func createNewReviewTapped(_ sender: UIButton) {
        guard let mostRecentPlacemark = mostRecentPlacemark,
            let address = mostRecentPlacemark.name,
            let latitude = mostRecentPlacemark.location?.coordinate.latitude,
            let longitude = mostRecentPlacemark.location?.coordinate.longitude
        else { return }
            
            let alertController = UIAlertController(title: "To add a new review", message: "please enter restaurant name below", preferredStyle: .alert)
            let continueButton = UIAlertAction(title: "Continue", style: .default) { (action) in
                let restaurantNameTextField = alertController.textFields![0]
                
                if restaurantNameTextField.text != "" {
                    let newRestaurant = Restaurant(address: address, cusineType: "", latitude: String(Double(latitude)), longitude: String(Double(longitude)), name: restaurantNameTextField.text ?? "")
                    restaurantNameTextField.endEditing(true)
                    self.restaurantBeingPassed = newRestaurant
                    self.performSegue(withIdentifier: "AddReviewSegue", sender: self)
                }
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Enter Restaurant Name Here..."
                textField.textColor = .systemPurple
            }
            alertController.addAction(continueButton)
            alertController.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
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
                NSLog("Name of placemark: \(placemark.name)")
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("location error: \(error)")
    }
}

//MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //let button = UIButton(type: .detailDisclosure)
//        guard let restaurant = annotation as? Restaurant else { return nil }
//        restaurant.name = "BillyBOBS"
//        restaurant.latitude = String(Double(mostRecentPlacemark?.location?.coordinate.latitude ?? 0.0))
//        restaurant.longitude = String(Double(mostRecentPlacemark?.location?.coordinate.longitude ?? 0.0))
//
//        mapView.addAnnotation(restaurant)
        
        var marker: MKMarkerAnnotationView?
        
        if restaurants.count > 0 {
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ReviewView") as? MKMarkerAnnotationView else {
                fatalError("Incorrect Identifier")
            }
            annotationView.canShowCallout = true
            annotationView.isEnabled = true
            //annotationView.rightCalloutAccessoryView = button
            marker = annotationView
        }
        
        return marker
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        let restaurant = view.annotation as! Restaurant
//        let placeName = restaurant.name
//        let placeInfo = restaurant.address
//
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        ac.addAction(UIAlertAction(title: "Add Review", style: .default, handler: { (alert) in
//            self.restaurantBeingPassed = restaurant
//            self.performSegue(withIdentifier: "AddReviewSegue", sender: self)
//        }))
//        present(ac, animated: true)
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

