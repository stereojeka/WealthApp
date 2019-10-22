//
//  Asset.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/20/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import Foundation

struct Asset: Codable {
    
    let assetType: String
    let assetDescription: String
    let currency: String
    let startingDate: String
    let currentValuation: AssetValuation
    let historicalValuations: [AssetValuation]
    let category: AssetCategory
    
    var lastAssetIncome: Double {
        guard historicalValuations.indices.contains(historicalValuations.endIndex - 2) else { return 0}
        
        let currentValuationInCurrency = currentValuation.valuationInCurrency
        let previousValuationInCurrency = historicalValuations[historicalValuations.endIndex - 2].valuationInCurrency

        return currentValuationInCurrency - previousValuationInCurrency
    }
    
    var orderedValuations: [Date: Double] {
        let dict = Dictionary(grouping: historicalValuations, by: { $0.date })
        return dict.mapValues { array in
            return array[0].valuationInCurrency
        }
    }
}
