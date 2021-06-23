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
                let sport = data?["sport"] as! String
                let level = (data?["level"] as! NSNumber).floatValue
                let description = data?["description"] as! String
                let locationPermission = data?["locationPermission"] as! Bool
               // set fields to data
                self.txtName.text = name
                self.txtEmail.text = email
              //  self.txtSport.text = sport
                self.sldLevel.setValue(level, animated: true)
                self.txtDescription.text = description
                self.lblName.text = "\(name)"+"'s Profile"
                self.swtLocation.setOn(locationPermission, animated: true)
                
            } else {
               // default values
                self.sldLevel.setValue(1.0, animated: true)
                self.swtLocation.setOn(false, animated: true)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
// button handling
    @IBAction func handleLogout (_ target: UIButton){
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "signoutSegue", sender: nil)
    }
    
    @IBAction func handleApply(_ sender: Any) {
        // get input values
        let name = txtName.text
        let email = txtEmail.text
       // let sport = txtSport.text
        let level = sldLevel.value
        let description = txtDescription.text
        let locationPermission = swtLocation.isOn
        
        // store data to firebase
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        let docRef = db.collection("updated").document("\(uid)")
        docRef.setData([
            "name" : name!,
            "email" : email!,
         //   "sport" : sport!,
            "level" : level,
            "description" : description!,
            "locationPermission" : locationPermission
        ], merge: true)
        // dismiss view controller
        dismiss(animated: true, completion: nil)
    }

// connections
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtSport: UITextField!
    @IBOutlet weak var sldLevel: UISlider!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var swtLocation: UISwitch!
    
    
}
