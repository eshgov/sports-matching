//
//  LocationService.swift
//  Sports Matching
//
//  Created by Eshaan Govil on 16/10/20.
//  Copyright © 2020 Eshaan Govil. All rights reserved.
//

/*import Foundation
import CoreLocation

enum Result<T> {
    case success(T)
    case failure(Error)
}

final class LocationService: NSObject {
    private let manager: CLLocationManager
    
    init(manager: CLLocationManager = .init()){
        self.manager = manager
        super.init()
        manager.delegate = self
    }
    
    var newLocation: ((Result<CLLocation>) -> Void)?
    var didChangeStatus: ((Bool) -> Void)?
    
    var status: CLAuthorizationStatus{
        return CLLocationManager.authorizationStatus()
    }
    
    func requestLocationAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func getLocation() {
        manager.requestLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        newLocation?(.failure(error))
    }
    
    // get user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.sorted(by: {$0.timestamp > $1.timestamp}).first {
            newLocation?(.success(location))
        }
    }
    
    //authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted, .denied:
            didChangeStatus?(false)
        default:
            didChangeStatus?(true)
        }
    }
}
 */