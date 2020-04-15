//
//  StoryboardLodable.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
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
