//
//  DashboardNavigationController.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/20/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import UIKit

class DashboardNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadRootViewController()
    }
    
    func loadRootViewController() {
        let viewController = DashboardViewController.initFromStoryboard(name: "DashboardView")
        self.viewControllers = [viewController]
    }
}
