//
//  LocationViewController.swift
//  Sports Matching
//
//  Created by Eshaan Govil on 16/10/20.
//  Copyright © 2020 Eshaan Govil. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

var firstVisit: Bool!

class LocationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var allowButton: UIButton!
    
    
    
    
    
//    @IBOutlet weak var locationView: LocationView!
//    var locationService: LocationService?
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        locationView.didTapAllow = { [weak self] in
//            self?.locationService?.requestLocationAuthorization()
//        }
//
//        locationService?.didChangeStatus = {[weak self] success in
//            if success{
//                self?.locationService?.getLocation()
//            }
//        }
//
//        locationService?.newLocation = {[weak self] result in
//            switch result {
//            case .success(let location):
//                print(location)
//            case .failure(let error):
//                assertionFailure("Error getting user's location \(error)")
//            }
//        }
//
//    }
    
    let locationManager = CLLocationManager()

    
    
    
     override func viewDidLoad() {
        super.viewDidLoad()
        firstVisit = false
    }
    
    
    @IBAction func tappedDeny(_ sender: Any) {
        print("location denied.")
        performSegue(withIdentifier: "locationToHome", sender: nil)
    }
    
    
    @IBAction func tappedAllow(){
        print("tapped allow.")
        isAuthorizedtoGetUserLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
        if CLLocationManager.locationServicesEnabled() {
                   locationManager.requestLocation();
        }
        
        performSegue(withIdentifier: "locationToHome", sender: nil)
        
    }

     //if we have no permission to access user location, then ask user for permission.
    func isAuthorizedtoGetUserLocation() {

        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
            locationManager.requestWhenInUseAuthorization()
        }
    }


    //this method will be called each time when a user change his location access preference.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
            //do whatever init activities here.
            
            //store the user location here to firebase or somewhere
            var currentLoc = manager.location
            let db = Firestore.firestore()
            let userUID = Auth.auth().currentUser!.uid
            
            db.collection("users").document(userUID).setData(["latitude":"\(currentLoc!.coordinate.latitude)"], merge: true)
            db.collection("users").document(userUID).setData(["longitude":"\(currentLoc!.coordinate.longitude)"], merge: true)
            
        }
    }


     //this method is called by the framework on locationManager.requestLocation();
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("Did location updates is called")
        //print(locations)
        
        let currentLoc = manager.location
        //store the user location here to firebase or somewhere
        let db = Firestore.firestore()
        let userUID = Auth.auth().currentUser!.uid
        
        
        db.collection("users").document(userUID).setData(["latitude":"\(currentLoc!.coordinate.latitude)"], merge: true)
        db.collection("users").document(userUID).setData(["longitude":"\(currentLoc!.coordinate.longitude)"], merge: true)
        
        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }

    /*private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
        {

            let location = locations.last! as CLLocation

            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            print(center.latitude, center.longitude)
          
    }*/
}
