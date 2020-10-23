//
//  UsersListView.swift
//  Sports Matching
//
//  Created by Eshaan Govil on 21/10/20.
//  Copyright © 2020 Eshaan Govil. All rights reserved.
//

import UIKit
import Firebase

class UsersListView: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var usersCollectionRef: CollectionReference!
    
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //users = createArray()
        
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
                    let documentId = document.documentID
                    
                    let newUser = User(image: UIImage(named: "image-placeholder")!, name: name, sport: sport, distance: distance, level: level, documentId: documentId)
                    self.users.append(newUser)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    
   /* func createArray() -> [User] {
        var tempUsers: [User] = []
        
        let user1 = User(image: UIImage(named: "image-placeholder")!, name: "Eshaan", sport: "Cricket", distance: 0.1, level: "Advanced")
        let user2 = User(image: UIImage(named: "image-placeholder")!, name: "Smita", sport: "Tennis", distance: 0.3, level: "Intermediate")
        let user3 = User(image: UIImage(named: "image-placeholder")!, name: "Nike", sport: "Tennis", distance: 0.2, level: "Beginner")
        let user4 = User(image: UIImage(named: "image-placeholder")!, name: "Deepak", sport: "Golf", distance: 1.2, level: "Intermediate")
        let user5 = User(image: UIImage(named: "image-placeholder")!, name: "Example", sport: "test", distance: 1.2, level: "Intermediate")
        
        tempUsers.append(user1)
        tempUsers.append(user2)
        tempUsers.append(user3)
        tempUsers.append(user4)
        tempUsers.append(user5)
        
        return tempUsers
    } */
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
}
