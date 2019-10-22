//
//  DataProvider.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/20/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class DataProvider {
    
    var client: Client?
    
    var orderedAssetsTotals: [Date: Double]?
    
    var totalNetWorth: Double {
        guard let client = client else { return 0.0 }
        return client.totalNetWorth
    }
    
    var totalNetIncome: Double {
        guard let client = client else { return 0.0 }
        return client.totalNetIncome
    }
    
    var assetsWithinStructure: Double {
        guard let client = client else { return 0.0 }
        return client.assetsWithinStructure
    }
    
    var assetsExternalToStructure: Double {
        guard let client = client else { return 0.0 }
        return client.assetsExternalToStructure
    }
    
    var assetsFixedIncome: Double {
        guard let client = client else { return 0.0 }
        return client.assetsFixedIncome
    }
    
    init() {
        self.client = loadJson(from: "ngpo")
        self.orderedAssetsTotals = [Date: Double]()
        self.client?.assets.forEach({ asset in
            self.orderedAssetsTotals?.merge(asset.orderedValuations, uniquingKeysWith: { (current, new) -> Double in
                return current + new
            })
        })
    }
    
    func loadJson(from fileName: String) -> Client? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let list = try JSONDecoder().decode([Client].self, from: data)
                return list.first ?? nil
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    func getLastAssetDate() -> Date {
        guard let client = self.client else { return Date() }
        guard client.assets.count >= 0 else { return Date() }
        guard client.assets.count != 1 else { return client.assets[0].currentValuation.date }
        
        var lastDate = client.assets[0].currentValuation.date
        
        for index in 1..<client.assets.count {
            if client.assets[index].currentValuation.date > lastDate {
                lastDate = client.assets[index].currentValuation.date
            }
        }
        return lastDate
    }
}
