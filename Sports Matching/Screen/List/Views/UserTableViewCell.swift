import UIKit
import Firebase

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    var photoURL: String!
    
    func setUser(user: User) {
        photoURL = user.photoURL
        if photoURL != ""{
            let path = photoURL
            let reference = Storage.storage().reference(forURL: path!)
            
            reference.getData(maxSize: (300 * 1024 * 1024)) { (data, error) in
                if let err = error {
                    print(err)
                } else {
                    if let image  = data {
                        let myImage: UIImage! = UIImage(data: image)
                        //userImageView.sizeToFit()
                        //myImage.resize(withSize: CGSize(width: userImageView.width(), height: userImageView.height()), contentMode: .contentAspectFill)
                        self.userImageView.image = myImage
                    }
                }
            }
        }
        userNameLabel.text = user.name
        locationLabel.text = Int(user.distance).description
        levelLabel.text = user.level
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension UIImage {
    enum ContentMode {
        case contentFill
        case contentAspectFill
        case contentAspectFit
    }
    
    func resize(withSize size: CGSize, contentMode: ContentMode = .contentAspectFill) -> UIImage? {
        let aspectWidth = size.width / self.size.width
        let aspectHeight = size.height / self.size.height
        
        switch contentMode {
        case .contentFill:
            return resize(withSize: size)
        case .contentAspectFit:
            let aspectRatio = min(aspectWidth, aspectHeight)
            return resize(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
        case .contentAspectFill:
            let aspectRatio = max(aspectWidth, aspectHeight)
            return resize(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
        }
    }
    
    private func resize(withSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
