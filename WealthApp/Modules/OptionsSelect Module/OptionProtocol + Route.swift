//
//  OptionProtocol.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/20/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import Foundation

protocol OptionProtocol {
    var optionName: String { get }
}

protocol OptionSelectRoute {
    func showOptionSelectView(for options: [OptionProtocol], currentSelectedIndex: Int, completion: ((Int) -> Void)?)
}
