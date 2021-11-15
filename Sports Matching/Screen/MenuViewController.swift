import UIKit
import Firebase
import CoreLocation

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try! Auth.auth().signOut()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "loginViewController") as! LoginViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func signupTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "signupViewController") as! SignUpViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
