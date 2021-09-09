//
//  SettingsViewController.swift
//  Sports Matching
//
//  Created by Eshaan Govil on 2/1/21.
//  Copyright © 2021 Eshaan Govil. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // get data from firebase
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        let docRef = db.collection("updated").document("\(uid!)")
        docRef.getDocument { (document, error) in
            if document!.exists{
                let data = document?.data()
              
                let name = data?["name"] as! String
                let email = Auth.auth().currentUser?.email
               // let sport = data?["sport"] as! String
                let levelNumber = (data?["levelNumber"] as! NSNumber).floatValue
              //  let level = data?["level"] as! String
                let description = data?["description"] as! String
               // let locationPermission = data?["locationPermission"] as! Bool
                let isCoach = data?["coach"] as! Bool
               // set fields to data
                self.txtName.text = name
                self.txtEmail.text = email
              //  self.txtSport.text = sport
                self.sldLevel.setValue(levelNumber, animated: true)
                self.txtDescription.text = description
                self.lblName.text = "\(name)"+"'s Profile"
               // self.swtLocation.setOn(locationPermission, animated: true)
                self.swtCoach.setOn(isCoach, animated: true)
                
            } else {
               // default values
                self.sldLevel.setValue(1.0, animated: true)
               // self.swtLocation.setOn(false, animated: true)
                self.swtCoach.setOn(false, animated: true)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
// button handling
    @IBAction func handleLogout (_ target: UIButton){
        try! Auth.auth().signOut()
        //self.performSegue(withIdentifier: "signoutSegue", sender: nil)
        let vc = self.storyboard?.instantiateViewController(identifier: "menuViewController") as! MenuViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func handleApply(_ sender: Any) {
        // get input values
        let name = txtName.text
        let email = txtEmail.text!
       // let sport = txtSport.text
       
        let levelNumber = sldLevel.value
        var level: String
        if (levelNumber >= 0 && levelNumber <= 2/3) {
           level = "Beginner"
        } else if levelNumber > 2/3 && levelNumber <= 4/3 {
            level = "Intermediate"
        } else if levelNumber > 4/3 && levelNumber <= 2 {
            level = "Advanced"
        } else {
            level = "N/A"
        }
        
        let description = txtDescription.text
       // let locationPermission = swtLocation.isOn
        let userType = swtCoach.isOn
        // store data to firebase
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        let docRef = db.collection("updated").document("\(uid)")
        docRef.setData([
            "name" : name!,
           // "email" : email!,
         //   "sport" : sport!,
            "level" : level,
            "levelNumber" : levelNumber,
            "description" : description!,
           // "locationPermission" : locationPermission,
            "coach" : userType,
            "email" : email
        ], merge: true)
        
        Auth.auth().currentUser?.updateEmail(to: email) { error in
            if error != nil {
                // An error happened
            } else {
               // Email updated.
               }
            }
        
    }

// connections
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var sldLevel: UISlider!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var swtLocation: UISwitch!
    @IBOutlet weak var swtCoach: UISwitch!
    
    @IBAction func resetPassButton_Tapped(_ sender: Any) {
       // self.performSegue(withIdentifier: "toResetPassword", sender: nil)
        let vc = self.storyboard?.instantiateViewController(identifier: "forgotPassViewController") as! ForgotPassViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
