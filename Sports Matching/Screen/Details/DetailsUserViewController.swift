//
//  DetailsUserViewController.swift
//  Sports Matching
//
//  Created by Eshaan Govil on 16/10/20.
//  Copyright © 2020 Eshaan Govil. All rights reserved.
//

import UIKit
import MapKit

class DetailsUserViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var detailsUserView: DetailsUserView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userSport: UILabel!
    @IBOutlet weak var userLevel: UILabel!
    @IBOutlet weak var userDistance: UILabel!
    @IBOutlet weak var userDescription: UILabel!
    @IBOutlet weak var contactbtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var userData: User?
    
    /*
    var name = userData?.name as? String ?? "Name"
    var sport = userData?.sport as? String ?? "Sport"
    var level = userData?.level as? String ?? "Level"
    var distance: Double = userData?.distance as? String ?? "Distance"
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = userData?.name ?? "Name"
        userSport.text = userData?.sport ?? "Sport"
        userLevel.text = userData?.level ?? "Level"
        userDistance.text = "\(userData?.distance ?? 0.0) km"
        userDescription.text = "\(userData?.description ?? "User Description.")"
        
        
        
        // Do any additional setup after loading the view.
    }
    

}
