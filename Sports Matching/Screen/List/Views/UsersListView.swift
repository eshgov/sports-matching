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

class UsersListView: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var usersCollectionRef: CollectionReference!
    
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        usersCollectionRef = Firestore.firestore().collection("users")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        usersCollectionRef.getDocuments { (snapshot, error) in
            if let err = error{
                debugPrint("Error fetching users: \(err)")
            } else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    let data = document.data()
                    let name = data["name"] as? String ?? "Name"
                    let sport = data["sport"] as? String ?? "Sport"
                    let distance = data["distance"] as? Double ?? 0
                    let level = data["level"] as? String ?? "Level"
                    let description = data["description"] as? String ?? "Description"
                    let documentId = document.documentID
                    
                    let newUser = User(image: UIImage(named: "image-placeholder")!, name: name, sport: sport, distance: distance, level: level, description: description, documentId: documentId)
                    self.users.append(newUser)
                }
                self.tableView.reloadData()
            }
        }
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
