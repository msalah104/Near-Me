//
//  PlacesResponse.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import UIKit

struct PlacesResponse: Codable {
    var metaData = ""
    var response = ""
    var places: [Place]?
    
    private enum CodingKeys: String, CodingKey {
        case metaData
        case response
        case places
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
    }
}

struct ResponseMetaData: Codable {
    var code = 0
}
