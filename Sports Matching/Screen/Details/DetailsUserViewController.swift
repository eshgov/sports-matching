//
//  DetailsUserViewController.swift
//  Sports Matching
//
//  Created by Eshaan Govil on 16/10/20.
//  Copyright © 2020 Eshaan Govil. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailsUserViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var detailsUserView: DetailsUserView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLevel: UILabel!
    @IBOutlet weak var userDistance: UILabel!
    @IBOutlet weak var userDescription: UILabel!
    @IBOutlet weak var contactbtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var userData: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = userData?.name ?? "Name"
        userLevel.text = userData?.level ?? "Level"
        userDistance.text = "\(Int(userData?.distance ?? 0)) km"
        userDescription.text = "\(userData?.description ?? "User Description.")"
        
        self.mapView.mapType = MKMapType.standard
      
        let center = CLLocationCoordinate2D(latitude: userData?.location.latitude ?? 0, longitude: userData?.location.longitude ?? 0)
              let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
              self.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = userData!.location
            annotation.title = "User's Location"
            mapView.addAnnotation(annotation)
    }
    
    @IBAction func contactTapped(_ sender: Any) {
        let vc = ChatViewController(with: userData!.email)
        vc.isNewConversation = true
        vc.otherUserData = userData
        vc.title = userData?.name ?? "Name"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
