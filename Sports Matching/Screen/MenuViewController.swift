//
//  MenuViewController.swift
//  Sports Matching
//
//  Created by Eshaan Govil on 4/1/21.
//  Copyright © 2021 Eshaan Govil. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try! Auth.auth().signOut()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if let user = Auth.auth().currentUser {
//            self.performSegue(withIdentifier: "menuToHome", sender: nil)
//            let vc = UsersListView()
//            navigationController?.pushViewController(vc, animated: true)
//        }
        
       /*Auth.auth().addStateDidChangeListener { auth, user in
          if let user = user {
            // User is signed in. Show home screen
           // let vc = UsersListView()
            let vc = self.storyboard?.instantiateViewController(identifier: "usersListView") as! UINavigationController
            //self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true, completion: nil)
          } else {
            // No User is signed in. Show user the login screen
          }
        }*/
    }
    
    @IBAction func loginTapped(_ sender: Any) {
       
       // let vc = LoginViewController()
        let vc = self.storyboard?.instantiateViewController(identifier: "loginViewController") as! LoginViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func signupTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "signupViewController") as! SignUpViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
