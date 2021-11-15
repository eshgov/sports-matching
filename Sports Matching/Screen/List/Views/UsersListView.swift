import UIKit
import Firebase
import MapKit
import CoreLocation


class UsersListView: UIViewController{
    
    @IBAction func tappedProfile(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "settingsViewController") as! SettingsViewController
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
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
    
    @IBOutlet weak var tableView: UITableView!
    private var usersCollectionRef: CollectionReference = Firestore.firestore().collection("users")
    private var users = [User]()
    private var userTypeString: String!
    private var isUserCoach: Bool!
    private var wantCoachView: Bool!
    private var locValue: CLLocation! = CLLocation(latitude: 11.5564, longitude: 104.9282)
    private var handle: AuthStateDidChangeListenerHandle?
    public var uid: String! = Auth.auth().currentUser?.uid
    private var currentUserLevel: Double!
    
    override func viewWillAppear(_ animated: Bool) {
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in. Show home screen
                Auth.auth().updateCurrentUser(user, completion: nil)
            } else {
                // No User is signed in. Show user the login screen
                let vc = MenuViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        let getLocation = GetLocation()
        
        getLocation.run {
            if let location = $0 {
                print("location = \(location.coordinate.latitude) \(location.coordinate.longitude)")
                let userLatitude = location.coordinate.latitude
                let userLongitude = location.coordinate.longitude
                
                let db = Firestore.firestore()
                db.collection("users").document(self.uid).setData(["latitude":"\(userLatitude)","longitude":"\(userLongitude)"], merge: true)
                
                self.locValue = location
            } else {
                print("Get Location failed \(String(describing: getLocation.didFailWithError))")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document("\(self.uid!)")
        docRef.getDocument { (document, error) in
            if let document = document {
                if document.exists{
                    print("document exists in updated branch. \(self.uid!)")
                    
                    // check if user is coach or child if exists
                    let data = document.data()
                    
                    self.isUserCoach = data?["coach"] as? Bool ?? false
                    self.currentUserLevel = data?["levelNumber"] as? Double ?? 0
                    
                    if (self.isUserCoach) {
                        // current user is a coach
                        self.userTypeString = "coaches"
                        self.wantCoachView = false
                        print("user is a coach")
                        self.title = "Students Nearby"
                    } else {
                        // current user is a student
                        self.userTypeString = "children"
                        self.wantCoachView = true
                        print("user is a child")
                        self.title = "Coaches Nearby"
                    }
                } else {
                    print("document doesn't exist.")
                }
            }
        }
        // SEARCH IMPLEMENTATION
        navigationItem.searchController = searchController
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All"){
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
                
                for document in snap.documents {
                    
                    let data = document.data()
                    let name = data["name"] as? String ?? "Name"
                    let sport = data["sport"] as? String ?? "Sport"
                    let isCoach = data["coach"] as? Bool ?? false
                    let level = data["level"] as? String ?? "Level"
                    let description = data["description"] as? String ?? "Description"
                    let documentId = document.documentID
                    let email = data["email"] as? String ?? "email"
                    let photoURL = data["photoURL"] as? String ?? ""
                    
                    let location = CLLocationCoordinate2D(latitude: (data["latitude"] as? CLLocationDegrees ?? 0), longitude: (data["longitude"] as? CLLocationDegrees ?? 0) )
                    
                    let distance = self.locValue.distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude)) / 1000
                    print(distance)
                    
                    
                    let newUser = User(image: UIImage(named: "image-placeholder")!, name: name, sport: sport, distance: distance, level: level, description: description, documentId: documentId, isCoach: isCoach, location: location, email: email, photoURL: photoURL)
                    
                    print(photoURL)
                    
                    if photoURL != ""{
                        let path = photoURL
                        let reference = Storage.storage().reference(forURL: path)
                        
                        reference.getData(maxSize: (15 * 1024 * 1024)) { (data, error) in
                            if let err = error {
                                print(err)
                            } else {
                                if let image  = data {
                                    let myImage: UIImage! = UIImage(data: image)
                                    newUser.image = myImage
                                }
                            }
                        }
                    }
                    
                    if newUser.isCoach == self.wantCoachView {
                        self.users.append(newUser)
                        print("User added to table array.")
                    }
                    self.users = self.users.sorted {
                        $0.distance < $1.distance
                    }
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
        
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserTableViewCell
        
        let currentUser: User
        
        if isFiltering(){
            currentUser = self.filteredUsers[indexPath.row]
        } else {
            currentUser = self.users[indexPath.row]
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
