//
//  PlaceImageResponse.swift
//  Near Me
//
//  Created by Mohammed Salah on 14/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import UIKit

struct PlaceImageResponse: Codable {

    var metaData: ResponseMetaData?
    var imageResponse: PlacePhotoResponse?
    var image : PlaceImage?
    
    private enum CodingKeys: String, CodingKey {
        case metaData = "meta"
        case imageResponse = "response"
    }
    
    init(from decoder: Decoder) throws {
        let mainContrainer = try decoder.container(keyedBy: CodingKeys.self)
        self.metaData = try! mainContrainer.decode(ResponseMetaData.self, forKey: .metaData)
        self.imageResponse = try! mainContrainer.decode(PlacePhotoResponse.self, forKey: .imageResponse)
        getImage()
    }
    
    private mutating func getImage() {
        image =  self.imageResponse?.photos?.items?.first
    }
    
}

struct PlacePhotoResponse:Codable {
    var photos:PlacePhoto?
}

struct PlacePhoto:Codable {
    var items:[PlaceImage]?
}


