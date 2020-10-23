//
//  AppDelegate.swift
//  Sports Matching
//
//  Created by Eshaan Govil on 22/8/20.
//  Copyright © 2020 Eshaan Govil. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

//    let window = UIWindow()
//    let locationService = LocationService()
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       // FirebaseApp.configure()
        
        
//        switch locationService.status {
//        case .notDetermined, .denied, .restricted:
//            let locationViewController = storyboard.instantiateViewController(identifier: "LocationVC") as? LocationViewController
//            locationViewController?.locationService = locationService
//            window.rootViewController = locationViewController
//        default:
//            assertionFailure()
//        }
//
//        window.makeKeyAndVisible()
        
        // Override point for customization after application launch.
        return true
    }
    
    override init() {
        FirebaseApp.configure()
    }
}

