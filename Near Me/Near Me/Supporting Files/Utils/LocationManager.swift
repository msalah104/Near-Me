//
//  File.swift
//  Near Me
//
//  Created by Mohammed Salah on 13/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import Foundation

protocol LocationManager: AnyObject {
    func updateMeWhenLocationChange(_ me: LocationDelegate)

    func getMyCurrentLocation(_ me: LocationDelegate)

    func setUpdateDistnace(_ distance: Double)
}
