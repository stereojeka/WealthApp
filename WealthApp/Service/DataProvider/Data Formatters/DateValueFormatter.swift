//
//  DateValueFormatter.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/22/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import Foundation
import Charts

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
