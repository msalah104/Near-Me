//
//  Extensions.swift
//  SwiftyBeaver
//
//  Created by Sebastian Kreutzberger on 13.12.17.
//  Copyright © 2017 Sebastian Kreutzberger. All rights reserved.
//

import Foundation

extension String {
    /// cross-Swift compatible characters count
    var length: Int {
        return count
    }

    /// cross-Swift-compatible first character
    var firstChar: Character? {
        return first
    }

    /// cross-Swift-compatible last character
    var lastChar: Character? {
        return last
    }

    /// cross-Swift-compatible index
    func find(_ char: Character) -> Index? {
        #if swift(>=5)
            return firstIndex(of: char)
        #else
            return index(of: char)
        #endif
    }
}
