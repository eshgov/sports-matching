//
//  DetailsUserView.swift
//  Sports Matching
//
//  Created by Eshaan Govil on 16/10/20.
//  Copyright © 2020 Eshaan Govil. All rights reserved.
//

import UIKit
import MapKit

@IBDesignable class DetailsUserView: BaseView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var contactButton: UIButton!
    
    
    @IBAction func contactAction(_sender: UIButton){
        
    }
    
}
