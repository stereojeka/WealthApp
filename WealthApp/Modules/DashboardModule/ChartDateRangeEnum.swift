//
//  ChartDateRangeEnum.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/20/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import Foundation

enum ChartDateRange: String, CaseIterable, OptionProtocol {
    
    case oneDay = "1 Day"
    case oneWeek = "1 Week"
    case oneMonth = "1 Month"
    case oneQuarter = "1 Quarter"
    case sixMonth = "6 Month"
    case oneYear = "1 Year"
    case allTime = "All Time"
    
    var optionName: String {
        return self.rawValue
    }
    
    var shortcut: String {
        switch self {
        case .oneDay:
            return "1D"
        case .oneWeek:
            return "1W"
        case .oneMonth:
            return "1M"
        case .oneQuarter:
            return "1Q"
        case .sixMonth:
            return "6M"
        case .oneYear:
            return "1Y"
        case .allTime:
            return "ALL"
        }
    }
    
    func indexOfSelected() -> Int {
        for (index, range) in ChartDateRange.allCases.enumerated() {
            if self == range {
                return index
            }
        }
        return 0
    }
}

extension ChartDateRange {
    
    init(from selectedIndex: Int) {
        for (index, range) in ChartDateRange.allCases.enumerated() {
            if index == selectedIndex {
                self = range
                return
            }
        }
        self = .oneQuarter
    }
}
