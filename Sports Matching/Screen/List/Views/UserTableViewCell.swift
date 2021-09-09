//
//  UserTableViewCell.swift
//  Sports Matching
//
//  Created by Eshaan Govil on 16/10/20.
//  Copyright © 2020 Eshaan Govil. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    
    func setUser(user: User) {
        userImageView.image = user.image
        userNameLabel.text = user.name
        sportLabel.text = user.sport
        locationLabel.text = Int(user.distance).description
        levelLabel.text = user.level
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
        
    }

}
