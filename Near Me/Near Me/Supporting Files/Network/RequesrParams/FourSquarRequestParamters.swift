//
//  FourSquarRequestParamters.swift
//  Near Me
//
//  Created by Mohammed Salah on 13/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import UIKit

class FourSquarRequestParamters: BaseRequestParamters {
    
    
    var location = ""
    var limit = 1

    
    init(long:Double, lat:Double) {
        super.init()
        location = "\(long),\(lat)"
        limit = 1
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    
    private enum CodingKeys: String, CodingKey {
        case location = "ll"
        case clientId = "client_id"
        case secretId = "client_secret"
        case apiVersion = "v"
        case limit = "limit"
    }
    
    override func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(clientId, forKey: .clientId)
         try container.encode(secretId, forKey: .secretId)
         try container.encode(apiVersion, forKey: .apiVersion)
        try container.encode(location, forKey: .location)
        try container.encode(limit, forKey: .limit)
         
     }

}
