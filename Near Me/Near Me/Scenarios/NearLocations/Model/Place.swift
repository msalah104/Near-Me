//
//  Place.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import UIKit

class Place: Codable {
    struct Location:Codable {
        var address:String?
    }
    
    var id:String?
    var name:String?
    var address:String?
    var imageUrl:String?
    
    private var location: Location?
    private enum CodingKeys: String, CodingKey {
        case name
        case id
        case location
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let mainContrainer = try decoder.container(keyedBy: CodingKeys.self)
        name = try! mainContrainer.decode(String.self, forKey: .name)
        id = try! mainContrainer.decode(String.self, forKey: .id)
        location = try! mainContrainer.decode(Location.self, forKey: .location)
        address = location?.address
    }
    
    func getCopy() -> Place {
        let place = Place ()
        place.id = self.id
        place.name = self.name
        place.address = self.address
        place.imageUrl = self.imageUrl
        return place
    }
}




