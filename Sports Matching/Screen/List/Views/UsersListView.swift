//
//  UsersListView.swift
//  Sports Matching
//
//  Created by Eshaan Govil on 21/10/20.
//  Copyright © 2020 Eshaan Govil. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation


class UsersListView: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    @IBOutlet weak var tableView: UITableView!
    private var usersCollectionRef: CollectionReference!
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        usersCollectionRef = Firestore.firestore().collection("updated")
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        var locationPermission: Bool
        let uid = Auth.auth().currentUser!.uid
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
            print("not determined.")
                locationPermission = false
            locationManager?.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
             print("authorized.")
                locationPermission = true
            @unknown default:
              print("default.")
                locationPermission = false
              }
        } else {
            print("location services not enabled.")
            locationPermission = false
        }

        let docRef = usersCollectionRef.document("\(uid)")
        docRef.setData(["locationPermission": locationPermission], merge: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        
        let docRef = db.collection("updated").document("\(uid)")
        docRef.getDocument { (document, error) in
            if let document = document {
            
            if document.exists{
                print("document exists in updated branch.")
            } else {
                self.performSegue(withIdentifier: "homeToSettings", sender: nil)
            }
            }
        }
        
        /*func hasLocationPermission() -> Bool {
               var hasPermission = false
               if CLLocationManager.locationServicesEnabled() {
                   switch CLLocationManager.authorizationStatus() { // <= 'authorizationStatus()' was deprecated in iOS 14.0
                   case .notDetermined, .restricted, .denied:
                       hasPermission = false
                   case .authorizedAlways, .authorizedWhenInUse:
                       hasPermission = true
                   @unknown default:
                       hasPermission = false
                     }
               } else {
                    hasPermission = false
               }
                return hasPermission
        }
        
        if hasLocationPermission(){
            self.performSegue(withIdentifier: "homeToLocation", sender: nil)
        }*/
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        usersCollectionRef.getDocuments { (snapshot, error) in
            if let err = error{
                debugPrint("Error fetching users: \(err)")
            } else {
                guard let snap = snapshot else {return}
                self.users.removeAll()
                let db = Firestore.firestore()
                
                
                //let currentLatitude = db.collection("users").document("\(Auth.auth().currentUser?.uid)").get
                for document in snap.documents {
                    
                    let data = document.data()
                    
                    /*func getCurrentCoordinate(completion: @escaping (CLLocation) -> ()) -> CLLocation{
                        var currentCoordinate: CLLocation
                        db.collection("users").document("\(String(describing: Auth.auth().currentUser?.uid))").getDocument { (document, error) in
                            if let document = document, document.exists {
                                //access data here
                                let currentData = document.data()
                                let currentLatitude = currentData?["latitude"] as? CLLocationDegrees
                                let currentLongitude = currentData?["longitude"] as? CLLocationDegrees
                                //print(currentLatitude, currentLongitude)
                                currentCoordinate = CLLocation(latitude: currentLatitude ?? 0, longitude: currentLongitude ?? 0)
                                //return currentCoordinate
                            } else {
                                print("Current User Document does not exist")
                                currentCoordinate = CLLocation(latitude: 0, longitude: 0)
                            }
                            completion(currentCoordinate)
                        }
                        return currentCoordinate
                    }*/
                    
                    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                        let locValue:CLLocation = manager.location!
                        print("locations = \(locValue.coordinate.latitude) \(locValue.coordinate.longitude)")
                    }
                    
                    let name = data["name"] as? String ?? "Name"
                    let sport = data["sport"] as? String ?? "Sport"
                    
                    let viewLatitude = data["latitude"] as? CLLocationDegrees ?? nil
                    let viewLongitude = data["longitude"] as? CLLocationDegrees ?? nil
                    let viewCoordinate: CLLocation = CLLocation(latitude: viewLatitude ?? 0, longitude: viewLongitude ?? 0)
                    
                    //let distance = .distance(from: viewCoordinate) / 1000
                    let level = data["level"] as? String ?? "Level"
                    let description = data["description"] as? String ?? "Description"
                    let documentId = document.documentID
                    
                    let newUser = User(image: UIImage(named: "image-placeholder")!, name: name, sport: sport, distance: 0, level: level, description: description, documentId: documentId)
                    self.users.append(newUser)
                    //let distance = data["distance"] as? Double ?? 0
                    
                }
                self.tableView.reloadData()
            }
        }
    }
    
    //this method will be called each time when a user change his location access preference.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
            //store the user location here to firebase
            //let currentLoc = manager.location
            let db = Firestore.firestore()
            let userUID = Auth.auth().currentUser!.uid
            
            //db.collection("updated").document(userUID).setData(["latitude":"\(manager.location!.coordinate.latitude)", "longitude":"\(manager.location!.coordinate.longitude)"], merge: true)
            
        }
    }
    //this method is called by the framework on locationManager.requestLocation();
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       //print("Did location updates is called")
       print(locations)
       
       //let currentLoc = manager.location
       //store the user location here to firebase
       let db = Firestore.firestore()
       let userUID = Auth.auth().currentUser!.uid
       
       
    db.collection("updated").document(userUID).setData(["latitude":"\(manager.location!.coordinate.latitude)","longitude":"\(manager.location!.coordinate.longitude)"], merge: true)
       
       
   }

   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print("Did location updates is called but failed getting location \(error)")
   }
   
}

extension UsersListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserTableViewCell
        
        cell.setUser(user: user)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailsUserViewController") as? DetailsUserViewController
        
        vc?.userData = self.users[indexPath.row]
        
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
