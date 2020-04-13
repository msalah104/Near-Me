//
//  Container+Extension.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import Foundation

import Swinject
import SwinjectStoryboard

extension Container {
    /**
     Retrieves UIViewController of the specified type. The UIViewController must conform to StoryboardLodable

     - Parameter serviceType: UIViewController type
     - Returns: UIViewController of specified type
     */
    func resolveViewController<ViewController: StoryboardLodable>(_ serviceType: ViewController.Type) -> ViewController {
        let sb = SwinjectStoryboard.create(name: serviceType.storyboardName, bundle: nil, container: self)
        let name = "\(serviceType)" // "\(serviceType)".replacingOccurrences(of: "ViewController", with: "")
        return sb.instantiateViewController(withIdentifier: name) as! ViewController
    }
}
