//
//  Place.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import UIKit

struct Place: Codable {

    var name:String?
    var address:[String]?
    var imageUrl:String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case address = "formattedAddress"
        case imageUrl
    }
}
