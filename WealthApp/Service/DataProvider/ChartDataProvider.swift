//
//  ChartDataProvider.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/21/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import RxCocoa
import RxSwift
import Charts

class ChartDataProvider {
    
    private let disposeBag = DisposeBag()
    
    var period = PublishSubject<ChartDateRange>()
    
    var lastAssetDate: Date
    
    let input: [Date: Double]
    
    var output = BehaviorRelay<[ChartDataEntry]>(value: [])
    
    init(assets: [Date: Double], period: ChartDateRange, lastAssetDate: Date) {
        self.input = assets
        self.lastAssetDate = lastAssetDate
        self.binding()
        self.period.onNext(period)
    }
    
    private func binding() {
        period.subscribe(onNext: { [weak self] value in
            self?.recalculate(with: value)
        }).disposed(by: disposeBag)
    }
    
    private func recalculate(with newPeriod: ChartDateRange) {
        let chartDates = getDatesArray(from: lastAssetDate, for: newPeriod)
        
        if chartDates.isEmpty {
            // For all period
            let filteredInput = input.sorted { (first, second) -> Bool in
                return first.key < second.key
            }
            output.accept(filteredInput.map { ChartDataEntry(x: Double($0.timeIntervalSince1970), y: $1) })
        } else {
            let newDataEntry = chartDates.compactMap { date -> ChartDataEntry? in
                if let total = input[date] {
                    return ChartDataEntry(x: Double(date.timeIntervalSince1970), y: total)
                }
                return nil
            }
            output.accept(newDataEntry)
        }
    }
    
    
    
    private func getDatesArray(from lastDate: Date, for period: ChartDateRange) -> [Date] {
        switch period {
        case .oneDay:
            if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: lastDate) {
                return Date.dates(from: newDate, to: lastDate)
            }
        case .oneWeek:
            if let newDate = Calendar.current.date(byAdding: .day, value: -7, to: lastDate) {
                return Date.dates(from: newDate, to: lastDate)
            }
        case .oneMonth:
            if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: lastDate) {
                return Date.dates(from: newDate, to: lastDate)
            }
        case .oneQuarter:
            if let newDate = Calendar.current.date(byAdding: .month, value: -3, to: lastDate) {
                return Date.dates(from: newDate, to: lastDate)
            }
        case .sixMonth:
            if let newDate = Calendar.current.date(byAdding: .month, value: -6, to: lastDate) {
                return Date.dates(from: newDate, to: lastDate)
            }
        case .oneYear:
            if let newDate = Calendar.current.date(byAdding: .year, value: -1, to: lastDate) {
                return Date.dates(from: newDate, to: lastDate)
            }
        case .allTime:
            return []
        }
        
        return [lastDate]
    }
}
