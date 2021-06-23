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

//var firstVisit: Bool!

class LocationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var allowButton: UIButton!
    
    let locationManager = CLLocationManager()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "First")
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
            //store the user location here to firebase or somewhere
            let currentLoc = manager.location
            let db = Firestore.firestore()
            let userUID = Auth.auth().currentUser!.uid
            
            db.collection("updated").document(userUID).setData(["latitude":"\(currentLoc!.coordinate.latitude)"], merge: true)
            db.collection("updated").document(userUID).setData(["longitude":"\(currentLoc!.coordinate.longitude)"], merge: true)
            
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
        
        
        db.collection("updated").document(userUID).setData(["latitude":"\(currentLoc!.coordinate.latitude)"], merge: true)
        db.collection("updated").document(userUID).setData(["longitude":"\(currentLoc!.coordinate.longitude)"], merge: true)
        
        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
    
}
