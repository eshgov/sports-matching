//
//  SignUpViewController.swift
//  Sports Matching
//
//  Created by Eshaan Govil on 14/10/20.
//  Copyright © 2020 Eshaan Govil. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        errorLabel.alpha = 0
    }
    
    // Check the Fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise it returns the error message.
    func validateFields() -> String?{
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        // Validate the Fields
        let error = validateFields()
        
        if error != nil {
            // Something wrong with fields
            showError(error!)
        } else {
            // Create cleaned versions of the data
            let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            // Create the User
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                // Check for Errors
                if err != nil {
                    // There was an error
                    self.showError("Error creating user.")
                } else {
                    // User was created succesfully, now store name
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(result!.user.uid).setData(["name" : name, "email": email,"uid": result!.user.uid]) { (error) in
                        
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data.")
                        }
                    }
                    // transition to home screen
//                    ref.observeAuthEventWithBlock({ authData in
//                        if authData != nil {
//                            // user authenticated
//                            print(authData)
//                            let vc = UsersListView()
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        } else {
//                            // No user is signed in
//                        }
//                    })
                    
                    Auth.auth().addStateDidChangeListener { auth, user in
                      if let user = user {
                        // User is signed in. Show home screen
                        //let vc = UsersListView()
                        let vc = self.storyboard?.instantiateViewController(identifier: "usersListView") as! UINavigationController
                        //self.navigationController?.pushViewController(vc, animated: true)
                        self.present(vc, animated: true, completion: nil)
                        
                      } else {
                        // No User is signed in. Show user the login screen
                        let vc = self.storyboard?.instantiateViewController(identifier: "menuViewController") as! MenuViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                      }
                    }
                }
            }
            
        }
        
    }
    
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    //    func transitionToHome(){
    //        let homeViewController = storyboard?.instantiateViewController(identifier: constants.Storyboard.homeViewController) as? HomeViewController
    //
    //        view.window?.rootViewController = homeViewController
    //        view.window?.makeKeyAndVisible()
    //
    //    }
    
}
