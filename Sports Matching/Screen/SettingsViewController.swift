import UIKit
import Firebase
import TinyConstraints

class SettingsViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        profileImageView.isUserInteractionEnabled = true
        
        // get data from firebase
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        let docRef = db.collection("users").document("\(uid!)")
        docRef.getDocument { (document, error) in
            if document!.exists{
                let data = document?.data()
                
                let name = data?["name"] as! String
                let email = Auth.auth().currentUser?.email
                let levelNumber = (data?["levelNumber"] as! NSNumber).floatValue
                let description = data?["description"] as! String
                let isCoach = data?["coach"] as! Bool
                
                // set fields to data
                self.txtName.text = name
                self.txtEmail.text = email
                self.sldLevel.setValue(levelNumber, animated: true)
                self.txtDescription.text = description
                self.lblName.text = "\(name)"+"'s Profile"
                self.swtCoach.setOn(isCoach, animated: true)
                let imageURL = data?["photoURL"]
                if imageURL as! String != "" {
                    let path = imageURL
                    let reference = Storage.storage().reference(forURL: path as! String)
                    
                    reference.getData(maxSize: (15 * 1024 * 1024)) { (data, error) in
                        if let err = error {
                            print(err)
                        } else {
                            if let image  = data {
                                let myImage: UIImage! = UIImage(data: image)
                                self.profileImageView.image = myImage
                            }
                        }
                    }
                } else {
                    self.profileImageView.image = UIImage(named: "image-placeholder")
                }
            } else {
                // default values
                self.sldLevel.setValue(1.0, animated: true)
                self.swtCoach.setOn(false, animated: true)
            }
        }
    }
    
    @IBAction func handleLogout (_ target: UIButton){
        try! Auth.auth().signOut()
        let vc = self.storyboard?.instantiateViewController(identifier: "menuViewController") as! MenuViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        ImagePickerManager().pickImage(self){ image in
            self.profileImageView.image = image
        }
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
                let docRef = db.collection("users").document("\(uid)")
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
        let docRef = db.collection("users").document("\(uid)")
        docRef.setData([
            "name" : name!,
            "level" : level,
            "levelNumber" : levelNumber,
            "description" : description!,
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
    @IBOutlet weak var swtCoach: UISwitch!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    @IBAction func resetPassButton_Tapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "forgotPassViewController") as! ForgotPassViewController
        self.present(vc, animated: true, completion: nil)
    }
}
