//
//  LocationManager.swift
//  NearBy
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import UIKit
import CoreLocation

enum LocationUpdateType {
    case CurrentLocation;
    case LocationUpdate
}

protocol LocationDelegate:AnyObject {
    // For monotoring user location change
    func userNewLocation(_ long:Double, _ lat:Double)
    func errorWhileRequestLocation(_ error: Error)
}

final class LocationUpdater: NSObject {
    
    // The distance you want to get notification when user exceed it, default is 500 meter
    fileprivate var filterDistance = Configurations.DefaultUpdateDsitance
    
    fileprivate var locationManager:CLLocationManager?
    fileprivate var updateType:LocationUpdateType?
    weak fileprivate var locationDelegate:LocationDelegate?
    fileprivate var previousLocation:CLLocation?
    
    fileprivate func startLocationManager(){
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.distanceFilter = self.filterDistance
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
    }
    
    fileprivate func restartLocationManger() {
        self.stopUpdating()
        self.startLocationManager()
    }
    
    fileprivate func stopUpdating()  {
        self.locationManager?.stopUpdatingLocation()
    }

}

extension LocationUpdater: LocationManager {
    func updateMeWhenLocationChange(_ me:LocationDelegate) {
        self.updateType = .LocationUpdate
        self.locationDelegate = me
        self.restartLocationManger()
    }
    
    func getMyCurrentLocation(_ me:LocationDelegate) {
        self.updateType = .CurrentLocation
        self.locationDelegate = me
        self.restartLocationManger()
    }
    
    func setUpdateDistnace(_ distance:Double){
        self.filterDistance = distance
    }
}

extension LocationUpdater: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var location:CLLocation?
        
        if locations.count > 0 {
            location = locations[0]
        } else {
            return
        }
        
        // To avoid sending same location
        if previousLocation == nil {
            previousLocation = location
        } else if (previousLocation?.coordinate.latitude == location?.coordinate.latitude) &&
            (previousLocation?.coordinate.longitude == location?.coordinate.longitude){
            return
        } else {
            previousLocation = location
        }
        
        // Stop location manager if we just need to get current location
        if self.updateType == .CurrentLocation {
            self.locationManager?.delegate = nil
            self.locationManager?.stopUpdatingLocation()
        }
        
        self.locationDelegate?.userNewLocation(location!.coordinate.longitude, location!.coordinate.latitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationDelegate?.errorWhileRequestLocation(error)
    }
}
