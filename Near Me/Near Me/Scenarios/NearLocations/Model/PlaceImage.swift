//
//  PlaceImage.swift
//  Near Me
//
//  Created by Mohammed Salah on 14/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import UIKit

struct PlaceImage: Codable {
    private var prefix: String?
    private var suffix: String?
    private var width: Int?
    private var height: Int?

    var imageUrl: String {
        return "\(prefix ?? "")\(width ?? 0)x\(height ?? 0)\(suffix ?? "")"
    }
}
