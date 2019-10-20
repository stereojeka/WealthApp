//
//  SwinjectStoryboard+DI.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/20/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    
    @objc class func setup() {
        defaultContainer.register(DataProvider.self) { _ in
            DataProvider()
        }.inObjectScope(.container)
        
        defaultContainer.register(DashboardViewModel.self) { resolver in
            DashboardViewModel(provider: resolver.resolve(DataProvider.self)!)
        }
        
        defaultContainer.storyboardInitCompleted(DashboardViewController.self) { (resolver, controller) in
            controller.viewModel = resolver.resolve(DashboardViewModel.self)!
        }
    }
}
