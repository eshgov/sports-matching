//
//  LoginViewController.swift
//  Sports Matching
//
//  Created by Eshaan Govil on 14/10/20.
//  Copyright © 2020 Eshaan Govil. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class LoginViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
   
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpElements()
    }

    func setUpElements(){
        errorLabel.alpha = 0
    }
    
    func validateFields() -> String?{
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func loginTapped(_ sender: Any) {
    
        // Validate text fields
        let error = validateFields()
        
        if error != nil {
            // Something wrong with fields
            showError(error!)
        } else {
            // Create cleaned versions of text fields
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                // Couldn't Sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
               
//                let homeViewController = self.storyboard?.instantiateViewController(identifier: constants.Storyboard.homeViewController) as? HomeViewController
                
//                self.view.window?.rootViewController = homeViewController
//                self.view.window?.makeKeyAndVisible()
   /*
                let isFirst = UserDefaults.standard.bool(forKey: "First")
                func hasLocationPermission() -> Bool {
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
                */
                self.performSegue(withIdentifier: "loginToHome", sender: nil)
                /*
                if isFirst == false && hasLocationPermission(){
                    self.performSegue(withIdentifier: "loginToHome", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "loginToLocation", sender: nil)
                }
 */
            }
        }
            
        
    }
    
}
    
    @IBAction func forgotPassButton_Tapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toForgotPassword", sender: nil)
    
    }
    
}
