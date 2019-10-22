//
//  DashboardViewModel.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/20/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import RxSwift
import RxCocoa

class DashboardViewModel {
    
    // MARK: - Dependencies
    let provider: DataProvider
    
    let chartDataProvider: ChartDataProvider
    
    // MARK: - Private
    private let disposeBag = DisposeBag()
    
    private let _totalNetWorth = BehaviorRelay<Double>(value: 0.0)
    private let _totalIncomeValue = BehaviorRelay<Double>(value: 0.0)
    private let _currentDateRange = BehaviorRelay<ChartDateRange>(value: .oneQuarter)
    private let _assetsWithinStructure = BehaviorRelay<Double>(value: 0.0)
    private let _assetsExternalToStructure = BehaviorRelay<Double>(value: 0.0)
    private let _assetsFixedIncome = BehaviorRelay<Double>(value: 0.0)
    
    private var _totalsIncome: Observable<Double> {
        return Observable.combineLatest(_assetsWithinStructure.asObservable(),
                                        _assetsExternalToStructure.asObservable(),
                                        _assetsFixedIncome.asObservable()) { value1, value2, value3 in
            return value1 + value2 + value3
        }
    }
    
    // MARK: - Public
    var totalNetWorth: Driver<Double> {
        return _totalNetWorth.asDriver()
    }
    
    var totalIncomeValue: Driver<Double> {
        return _totalIncomeValue.asDriver()
    }
    
    var currentDateRange: Driver<ChartDateRange> {
        return _currentDateRange.asDriver()
    }
    
    var assetsWithinStructure: Driver<Double> {
        return _assetsWithinStructure.asDriver()
    }
    
    var assetsExternalToStructure: Driver<Double> {
        return _assetsExternalToStructure.asDriver()
    }
    
    var assetsFixedIncome: Driver<Double> {
        return _assetsFixedIncome.asDriver()
    }
    
    var totalsIncome: Driver<Double> {
        return _totalsIncome.asDriver(onErrorJustReturn: 0.0)
    }
    
    var currentDateRangeIndex = BehaviorRelay<Int>(value: 0)
    
    // MARK: - Init
    init(provider: DataProvider) {
        self.provider = provider
        self.chartDataProvider = ChartDataProvider(assets: provider.orderedAssetsTotals!, period: .oneQuarter, lastAssetDate: provider.getLastAssetDate())
        self.binding()
    }
    
    private func binding() {
        _totalNetWorth.accept(provider.totalNetWorth)
        _totalIncomeValue.accept(provider.totalNetIncome)
        _assetsWithinStructure.accept(provider.assetsWithinStructure)
        _assetsExternalToStructure.accept(provider.assetsExternalToStructure)
        _assetsFixedIncome.accept(provider.assetsFixedIncome)
        _currentDateRange.subscribe(onNext: { [weak self] range in
            self?.currentDateRangeIndex.accept(range.indexOfSelected())
            self?.chartDataProvider.period.onNext(range)
        }).disposed(by: disposeBag)
    }
    
    func updateDateRange(value: ChartDateRange) {
        self._currentDateRange.accept(value)
    }
}
