//
//  StoryboardLodable.swift
//  ItunesAssignment
//
//  Created by AmrFawaz on 4/6/20.
//  Copyright © 2020 AmrFawaz. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardLodable: AnyObject {
    @nonobjc static var storyboardName: String { get }
}

protocol NearMeStoryboardLodable: StoryboardLodable {}

extension NearMeStoryboardLodable where Self: UIViewController {
    @nonobjc static var storyboardName: String {
        return "NearLocation"
    }
}

