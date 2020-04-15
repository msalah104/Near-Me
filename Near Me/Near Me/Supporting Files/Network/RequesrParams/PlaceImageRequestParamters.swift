//
//  PlaceImageRequestParamters.swift
//  Near Me
//
//  Created by Mohammed Salah on 14/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import UIKit

class PlaceImageRequestParamters: BaseRequestParamters {
    var id: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case clientId = "client_id"
        case secretId = "client_secret"
        case apiVersion = "v"
    }

    init(id: String) {
        super.init()
        self.id = id
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(clientId, forKey: .clientId)
        try container.encode(secretId, forKey: .secretId)
        try container.encode(apiVersion, forKey: .apiVersion)
    }
}
