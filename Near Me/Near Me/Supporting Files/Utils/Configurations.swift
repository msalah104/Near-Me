//
//  Configurations.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import UIKit


enum ProjectMode: String {
    case development
    case stage
    case production
}

class Configurations: NSObject {
    
    
    // Configurations
    static var mode: ProjectMode = .development
    static let DefaultSearchRadius = 1000.0
    static let DefaultUpdateDsitance = 500.0
    static let DefaultApiVersion = "20180323"
    
    static var BaseUrl: URL {
          if Configurations.mode == .development {
              return URL(string: "https://api.foursquare.com/v2/venues/")!
          } else if Configurations.mode == .production {
              return URL(string: "https://www.fly365.com/api/")!
          } else {
              return URL(string: "http://www.fly365stage.com/api/")!
          }
      }
    
     // Constants
      static let UPDATE_MODE = "Places_Update_Mode"
      static let CACH_PLACES = "cach"
      static let SUCCESS:Int = 200
}
