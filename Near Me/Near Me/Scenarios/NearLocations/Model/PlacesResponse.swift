//
//  PlacesResponse.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import UIKit

struct PlacesResponse: Codable {
    var metaData: ResponseMetaData?
    var response: PlacesGroupsResponse?
    var places: [Place]?

    private enum CodingKeys: String, CodingKey {
        case metaData = "meta"
        case response
    }

    init(from decoder: Decoder) throws {
        let mainContrainer = try decoder.container(keyedBy: CodingKeys.self)
        metaData = try! mainContrainer.decode(ResponseMetaData.self, forKey: .metaData)
        response = try! mainContrainer.decode(PlacesGroupsResponse.self, forKey: .response)
        updatePlaces()
    }

    private mutating func updatePlaces() {
        if let placesGroups = response?.groups {
            let items = placesGroups.flatMap { ($0.items ?? []) }
            places = items.map { $0.venue! }
        }
    }
}

struct ResponseMetaData: Codable {
    var code = 0
}
