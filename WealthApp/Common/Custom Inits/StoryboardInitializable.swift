//
//  StoryboardInitializable.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/20/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import UIKit

protocol StoryboardInitializable {
    static var storyboardIdentifier: String { get }
    static func initFromStoryboard(name: String) -> Self
}

extension StoryboardInitializable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }
    
    static func initFromStoryboard(name: String = "Main") -> Self {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}
