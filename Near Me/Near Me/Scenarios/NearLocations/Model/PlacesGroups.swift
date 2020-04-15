//
//  PlacesGroups.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import UIKit

struct PlacesGroupsResponse: Codable {
    var groups: [PlacesGroups]?
}

struct PlacesGroups: Codable {
    struct Item: Codable {
        var venue: Place?
    }

    var items: [Item]?
}
