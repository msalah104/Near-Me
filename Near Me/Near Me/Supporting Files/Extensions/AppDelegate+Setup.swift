//
//  AppDelegate+Setup.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import Foundation
import os.log
import Swinject
import SwinjectAutoregistration
import SwinjectStoryboard

extension AppDelegate {
    /**
     Set up the depedency graph in the DI container
     */
    internal func setupDependencies() {
        // services
        container.autoregister(LocationManager.self, initializer: LocationUpdater.init).inObjectScope(ObjectScope.container)

        // viewModel
        container.autoregister(NearMeViewModel.self, initializer: NearMeViewModel.init)

        // view controllers
        container.storyboardInitCompleted(NearMeViewController.self) { r, c in
            c.viewModel = r.resolve(NearMeViewModel.self)
        }
    }
}
