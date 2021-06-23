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

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let user = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "menuToHome", sender: nil)
            
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
                let homeViewController = UsersListView()
                
                homeViewController.performSegue(withIdentifier: "homeToLocation", sender: nil)
            }*/
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
