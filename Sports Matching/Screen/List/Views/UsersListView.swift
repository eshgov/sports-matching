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


class UsersListView: UIViewController{
    
   
    
    var filteredUsers = [User]()
    
    lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search..."
        sc.searchBar.sizeToFit()
        sc.searchBar.searchBarStyle = .prominent
        
        sc.searchBar.scopeButtonTitles = ["All", "Advanced", "Intermediate", "Beginner"]
        
        sc.searchBar.delegate = self
        
        return sc
    }()
  
    
  // var locationManager: CLLocationManager?
    @IBOutlet weak var tableView: UITableView!
    private var usersCollectionRef: CollectionReference = Firestore.firestore().collection("updated")
    private var users = [User]()
    private var userTypeString: String!
    private var isUserCoach: Bool!
    private var wantCoachView: Bool!
    private var locValue: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //locationManager?.requestWhenInUseAuthorization()
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        let uid = Auth.auth().currentUser!.uid
        
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("updated").document("\(uid)")
        docRef.getDocument { (document, error) in
            if let document = document {
            
            if document.exists{
                print("document exists in updated branch. \(uid)")
               // check if user is coach or child if exists
                
                let data = document.data()
                
                self.isUserCoach = data?["coach"] as? Bool ?? false
               /*
                let docRefForType = db.collection("coaches").document("\(uid)")
                docRefForType.getDocument { (document, error) in
                    if let document = document {
                    
                    if document.exists{
                        print("document exists in coaches branch. \(uid)")
                        self.userTypeString = "coaches"
                    } else {
                        print("document doesn't exist in coaches.")
                        self.userTypeString = "children"
                    }
                    }
                }*/
                
                if (self.isUserCoach) {
                    self.userTypeString = "coaches"
                    self.wantCoachView = false
                    print("user is a coach")
                } else {
                    self.userTypeString = "children"
                    self.wantCoachView = true
                    print("user is a child")
                }
            } else {
                print("document doesn't exist.")
                self.performSegue(withIdentifier: "homeToSettings", sender: nil)
            }
            }
        }
        
        let getLocation = GetLocation()
        getLocation.run {
            if let location = $0 {
                print("location = \(location.coordinate.latitude) \(location.coordinate.longitude)")
                let userLatitude = location.coordinate.latitude
                let userLongitude = location.coordinate.longitude
                
                let db = Firestore.firestore()
                let userUID = Auth.auth().currentUser!.uid

             db.collection("updated").document(userUID).setData(["latitude":"\(userLatitude)","longitude":"\(userLongitude)"], merge: true)
            } else {
                print("Get Location failed \(getLocation.didFailWithError)")
            }
        }
        
     /*   locationManager = CLLocationManager()
        locationManager?.delegate = self
        var locationPermission: Bool
       
        
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

        let docRefForLocationPermission = usersCollectionRef.document("\(uid)")
        docRefForLocationPermission.setData(["locationPermission": locationPermission], merge: true)
        
        */
// SEARCH IMPLEMENTATION
        //searchController.searchResultsUpdater = self
       navigationItem.searchController = searchController
    }
    
    
// end of viewDidLoad()

    func filterContentForSearchText(searchText: String, scope: String = "All"){
        // add parameter 'scope: String = "All"' when having sections
        filteredUsers = users.filter({ (user: User) -> Bool in
            let doesCategoryMatch = (scope == "All") || (user.level == scope)
            
            if isSearchBarEmpty(){
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && user.name.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }
 
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty() || searchBarScopeIsFiltering)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        usersCollectionRef.getDocuments { (snapshot, error) in
            if let err = error{
                debugPrint("Error fetching users: \(err)")
            } else {
                guard let snap = snapshot else {return}
                self.users.removeAll()
              //  let db = Firestore.firestore()
                
                
                //let currentLatitude = db.collection("users").document("\(Auth.auth().currentUser?.uid)").get
                for document in snap.documents {
                    
                    let data = document.data()
                    
                   /* func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
                        self.locValue = manager.location!
                        print("locations = \(self.locValue.coordinate.latitude) \(self.locValue.coordinate.longitude)")}*/
                    
                    
                    let name = data["name"] as? String ?? "Name"
                    let sport = data["sport"] as? String ?? "Sport"
                    let isCoach = data["coach"] as? Bool ?? false
                    
                   /* let viewLatitude = data["latitude"] as? CLLocationDegrees ?? 0
                    let viewLongitude = data["longitude"] as? CLLocationDegrees ?? 0
                    let viewCoordinate: CLLocation = CLLocation(latitude: viewLatitude ?? 0, longitude: viewLongitude ?? 0)
                    
                    let distance = self.locValue.distance(from: viewCoordinate) / 1000 */
                    let level = data["level"] as? String ?? "Level"
                    let description = data["description"] as? String ?? "Description"
                    let documentId = document.documentID
                    
                    let newUser = User(image: UIImage(named: "image-placeholder")!, name: name, sport: sport, distance: 0, level: level, description: description, documentId: documentId, isCoach: isCoach)
                    if newUser.isCoach == self.wantCoachView{
                        self.users.append(newUser)}
                    //let distance = data["distance"] as? Double ?? 0
                    
                }
                self.tableView.reloadData()
            }
        }
    }
 
}

extension UsersListView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope] )
    }
    
}

extension UsersListView: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
    
}

// LOCATION
/*
extension UsersListView: CLLocationManagerDelegate{
    //this method is called by the framework on locationManager.requestLocation();
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations is called")
          if let location = locations.last {
            let authStat = CLLocationManager.authorizationStatus()

                if authStat == .denied || authStat == .restricted || authStat == .notDetermined {
                    
                    let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings so that others can locate you", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                            print("Ok button tapped")})
                    
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    //do your firebase things.
                    let userLatitude = location.coordinate.latitude
                    let userLongitude = location.coordinate.longitude
                    
                    let db = Firestore.firestore()
                    let userUID = Auth.auth().currentUser!.uid

                 db.collection("updated").document(userUID).setData(["latitude":"\(userLatitude)","longitude":"\(userLongitude)"], merge: true)

                }
          }
      }
    
 //   this method will be called each time when a user change his location access preference.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
            
            let location = manager.location
            //store the user location here to firebase
              let authStat = CLLocationManager.authorizationStatus()

                  if authStat == .denied || authStat == .restricted || authStat == .notDetermined {
                      
                      let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings so that others can locate you", preferredStyle: .alert)
                      let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                              print("Ok button tapped")})
                      
                      alert.addAction(ok)
                      self.present(alert, animated: true, completion: nil)
                      
                  } else {
                      //do your firebase things.
                    let userLatitude = location?.coordinate.latitude
                    let userLongitude = location?.coordinate.longitude
                      
                      let db = Firestore.firestore()
                      let userUID = Auth.auth().currentUser!.uid

                   db.collection("updated").document(userUID).setData(["latitude":"\(userLatitude)","longitude":"\(userLongitude)"], merge: true)

            }
        }
    }


   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print("Did location updates is called but failed getting location \(error)")
   }
}
*/

public class GetLocation: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var locationCallback: ((CLLocation?) -> Void)!
    var locationServicesEnabled = false
    var didFailWithError: Error?

    public func run(callback: @escaping (CLLocation?) -> Void) {
        locationCallback = callback
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.requestWhenInUseAuthorization()
        locationServicesEnabled = CLLocationManager.locationServicesEnabled()
        if locationServicesEnabled { manager.startUpdatingLocation() }
        else { locationCallback(nil) }
    }

   public func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        locationCallback(locations.last!)
        manager.stopUpdatingLocation()
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didFailWithError = error
        locationCallback(nil)
        manager.stopUpdatingLocation()
    }

    deinit {
        manager.stopUpdatingLocation()
    }
}

extension UsersListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {return filteredUsers.count}
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserTableViewCell
        
        let currentUser: User
        
        if isFiltering(){
            currentUser = filteredUsers[indexPath.row]
        } else {
            currentUser = users[indexPath.row]
        }
        
        cell.setUser(user: currentUser)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailsUserViewController") as? DetailsUserViewController
        
       
        
        if isFiltering(){
            vc?.userData = self.filteredUsers[indexPath.row]
        } else {
            vc?.userData = self.users[indexPath.row]
        }
        
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
