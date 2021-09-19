//
//  SettingsViewController.swift
//  Sports Matching
//
//  Created by Eshaan Govil on 2/1/21.
//  Copyright © 2021 Eshaan Govil. All rights reserved.
//

import UIKit
import Firebase
import TinyConstraints

class SettingsViewController: UIViewController {

    let profileImageViewWidth: CGFloat = 100
    
    lazy var profileImageView: UIImageView = {
          let iv = UIImageView()
          iv.image = #imageLiteral(resourceName: "image-placeholder").withRenderingMode(.alwaysOriginal)
          iv.contentMode = .scaleAspectFill
          iv.layer.cornerRadius = profileImageViewWidth / 2
          iv.layer.masksToBounds = true
          return iv
      }()
    
    lazy var profileImageButton: UIButton = {
            var button = UIButton(type: .system)
            button.backgroundColor = .clear
            button.layer.cornerRadius = profileImageViewWidth / 2
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(profileImageButtonTapped), for: .touchUpInside)
            return button
        }()
    
    fileprivate func setupViews() {
        view.backgroundColor = .white
        addViews()
        constrainViews()
    }
    
    fileprivate func addViews() {
        view.addSubview(profileImageView)
        view.addSubview(profileImageButton)
    }
    
    fileprivate func constrainViews() {
        profileImageView.topToSuperview(offset: 36, usingSafeArea: true)
        profileImageView.centerXToSuperview()
        profileImageView.width(profileImageViewWidth)
        profileImageView.height(profileImageViewWidth)
        
        profileImageButton.edges(to: profileImageView)
    }
    
    @objc fileprivate func profileImageButtonTapped() {
           print("Tapped button")
            showImagePickerControllerActionSheet()
       }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
       /* profileImageView.image = UIImage(named: "image-placeholder")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        profileImageView.isUserInteractionEnabled = true */
        
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
                let imageURL = data?["photoURL"]
                
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
        let vc = self.storyboard?.instantiateViewController(identifier: "menuViewController") as! MenuViewController
        //navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        showImagePickerControllerActionSheet()
    }
    
    @objc func savePhoto() {
        guard let image = profileImageView.image else {return}
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imagePickerController(_:didFinishPickingMediaWithInfo:)), nil)
    }
    
    @objc func uploadPhoto() {
        guard let image = profileImageView.image, let data = image.jpegData(compressionQuality: 1.0) else {
            let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                print ("Ok Button tapped")
            }
            alert.addAction(OKAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let imageName = UUID().uuidString
        let imageReference = Storage.storage().reference().child(imageName)
        imageReference.putData(data, metadata: nil) { metadata, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            imageReference.downloadURL { url, err in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                
                guard let url = url else {
                    let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        print ("Ok Button tapped")
                    }
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                let urlString = url.absoluteString
                
                let db = Firestore.firestore()
                let uid = Auth.auth().currentUser!.uid
                let docRef = db.collection("updated").document("\(uid)")
                docRef.setData(["photoURL": urlString], merge: true) { err in
                    if let err = err {
                        print(err.localizedDescription)
                        return
                    }
                }
            }
        }
    }
    
    @IBAction func handleApply(_ sender: Any) {
        // get input values
        let name = txtName.text
        let email = txtEmail.text!
        
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
        uploadPhoto()
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

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {
        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Take from Camera", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: "Choose your image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profileImageView.image = editedImage.withRenderingMode(.alwaysOriginal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profileImageView.image = originalImage.withRenderingMode(.alwaysOriginal)
        }
        dismiss(animated: true, completion: nil)
    }
}
