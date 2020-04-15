//
//  NearCoordinator.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import Swinject
import UIKit

protocol Coordinator: AnyObject {
    /**
     Entry point starting the coordinator
     */
    func start()
}

class NearCoordinator: Coordinator {
    // MARK: - Properties

    private let NearMeNavigationViewID = "mainStart"
    private let NearMeViewID = "nearMe"

    private let window: UIWindow?
    private var navigationController: UINavigationController?
    private let storyboard = UIStoryboard(name: "NearLocation", bundle: nil)
    private let container: Container!

    // MARK: - Coordinator core

    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
        navigationController = storyboard.instantiateViewController(withIdentifier: NearMeNavigationViewID) as? UINavigationController
    }

    func start() {
        let vc = container.resolveViewController(NearMeViewController.self)
        navigationController?.viewControllers = [vc]
        window?.rootViewController = navigationController
    }
}
