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
    
    var totalNetWorth: Double {
        guard let client = client else { return 0.0 }
        return client.totalNetWorth
    }
    
    var totalNetIncome: Double {
        guard let client = client else { return 0.0 }
        return client.totalNetIncome
    }
    
    init() {
        self.client = loadJson(from: "ngpo")
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
}
