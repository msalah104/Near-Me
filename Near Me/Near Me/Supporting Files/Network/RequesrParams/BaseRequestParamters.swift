//
//  BaseRequestParamters.swift
//  Near Me
//
//  Created by Mohammed Salah on 13/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import UIKit

class BaseRequestParamters: RequestParamters {
    let KeysFileName = "keys"
    
    var clientId = ""
    var secretId = ""
    var apiVersion = ""
    
    private enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case secretId = "client_secret"
        case apiVersion = "v"
    }
    
    init() {
        let filePath = Bundle.main.path(forResource: KeysFileName, ofType: "plist")
        
        // Put the keys in a dictionary
        let plist = NSDictionary(contentsOfFile: filePath!)
        
        // Pull the value for the key
        clientId = plist?.object(forKey: CodingKeys.clientId.rawValue) as! String
        secretId = plist?.object(forKey: CodingKeys.secretId.rawValue) as! String
        apiVersion = Configurations.DefaultApiVersion
        
    }
}
