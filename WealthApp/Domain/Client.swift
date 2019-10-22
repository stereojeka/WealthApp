//
//  Client.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/20/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import Foundation

struct Client: Codable {
    
    let clientName: String
    let drafts: [Message]
    let inboxMessages: [Message]
    let sentItems: [Message]
    let assets: [Asset]
    
    var totalNetWorth: Double {
        return assets.reduce(0.0) { result, asset -> Double in
            return result + asset.currentValuation.valuationInCurrency
        }
    }
    
    var totalNetIncome: Double {
        return assets.reduce(0.0) { result, asset -> Double in
            return result + asset.lastAssetIncome
        }
    }
    
    var assetsWithinStructure: Double {
        getAssetsIncome(by: .ASSETS_WITHIN_STRUCTURE)
    }
    
    var assetsExternalToStructure: Double {
        getAssetsIncome(by: .ASSETS_OUTSIDE_STRUCTURE)
    }
    
    var assetsFixedIncome: Double {
        getAssetsIncome(by: .FIXED_INCOME_ASSETS)
    }
    
    private func getAssetsIncome(by category: AssetCategory) -> Double {
        return assets.reduce(0.0) { result, asset -> Double in
            if asset.category == category {
                return result + asset.lastAssetIncome
            }
            return result
        }
    }
}
