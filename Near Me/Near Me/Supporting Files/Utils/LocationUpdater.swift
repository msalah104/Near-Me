//
//  LocationManager.swift
//  NearBy
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import CoreLocation
import UIKit

enum LocationUpdateType {
    case CurrentLocation
    case LocationUpdate
}

protocol LocationDelegate: AnyObject {
    // For monotoring user location change
    func userNewLocation(_ long: Double, _ lat: Double)
    func errorWhileRequestLocation(_ error: Error)
}

final class LocationUpdater: NSObject {
    // The distance you want to get notification when user exceed it, default is 500 meter
    private var filterDistance = Configurations.DefaultUpdateDsitance

    private var locationManager: CLLocationManager?
    private var updateType: LocationUpdateType?
    private weak var locationDelegate: LocationDelegate?
    private var previousLocation: CLLocation?

    fileprivate func startLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.distanceFilter = filterDistance
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }

    fileprivate func restartLocationManger() {
        stopUpdating()
        startLocationManager()
    }

    fileprivate func stopUpdating() {
        locationManager?.stopUpdatingLocation()
    }
}

extension LocationUpdater: LocationManager {
    func updateMeWhenLocationChange(_ me: LocationDelegate) {
        updateType = .LocationUpdate
        locationDelegate = me
        restartLocationManger()
    }

    func getMyCurrentLocation(_ me: LocationDelegate) {
        updateType = .CurrentLocation
        locationDelegate = me
        restartLocationManger()
    }

    func setUpdateDistnace(_ distance: Double) {
        filterDistance = distance
    }
}

extension LocationUpdater: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var location: CLLocation?

        if !locations.isEmpty {
            location = locations[0]
        } else {
            return
        }

        // To avoid sending same location
        if previousLocation == nil {
            previousLocation = location
        } else if previousLocation?.coordinate.latitude == location?.coordinate.latitude,
            previousLocation?.coordinate.longitude == location?.coordinate.longitude {
            return
        } else {
            previousLocation = location
        }

        // Stop location manager if we just need to get current location
        if updateType == .CurrentLocation {
            locationManager?.delegate = nil
            locationManager?.stopUpdatingLocation()
        }

        locationDelegate?.userNewLocation(location!.coordinate.longitude, location!.coordinate.latitude)
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        locationDelegate?.errorWhileRequestLocation(error)
    }
}
