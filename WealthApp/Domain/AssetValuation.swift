//
//  AssetValuation.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/20/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import Foundation

struct AssetValuation: Codable {
    
    let valuationDate: String
    let valuationInGBP: Double
    let valuationInCurrency: Double
}
