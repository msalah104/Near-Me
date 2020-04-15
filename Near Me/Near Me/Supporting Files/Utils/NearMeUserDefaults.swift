//
//  NearByUserDefaults.swift
//  Near Me
//
//  Created by Mohammed Salah on 15/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import UIKit

class NearMeUserDefaults: NSObject {
    // Constants
    static let UpdateModeKey = "Places_Update_Mode"

    // Declare the defaults
    static let defaults: UserDefaults = UserDefaults.standard

    static func setCurrentUpdateMode(_ updateMode: PlacesUpdateType) {
        print("Save Types: \(updateMode.rawValue)")
        defaults.set(updateMode.rawValue, forKey: UpdateModeKey)
    }

    static func getCurrentUpdateMode() -> PlacesUpdateType {
        if let mode = defaults.object(forKey: UpdateModeKey) {
            print(" Get Types: \(PlacesUpdateType(rawValue: mode as! String)!)")
            return PlacesUpdateType(rawValue: mode as! String)!
        } else {
            // Default state is single time update
            return .Realtime
        }
    }
}
