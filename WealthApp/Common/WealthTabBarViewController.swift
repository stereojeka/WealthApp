//
//  WealthTabBarViewController.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/20/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import UIKit

class WealthTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.barTintColor = .darkishPurple
        tabBar.unselectedItemTintColor = .veryLightPink
        tabBar.tintColor = .white
    }
}
