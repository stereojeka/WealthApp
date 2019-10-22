//
//  InboxNavigationController.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/22/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import UIKit

class InboxNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadRootViewController()
    }
    
    func loadRootViewController() {
        let viewController = InboxViewController.initFromStoryboard(name: "InboxView")
        self.viewControllers = [viewController]
    }
}
