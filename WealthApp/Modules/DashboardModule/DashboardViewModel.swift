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
    
    // MARK: - Private
    private let disposeBag = DisposeBag()
    
    private let _totalNetWorth = BehaviorRelay<Double>(value: 0.0)
    private let _totalIncomeValue = BehaviorRelay<Double>(value: 0.0)
    private let _currentDateRange = BehaviorRelay<ChartDateRange>(value: .sixMonth)
    
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
    
    var currentDateRangeIndex = BehaviorRelay<Int>(value: 0)
    
    init(provider: DataProvider) {
        self.provider = provider
        self.binding()
    }
    
    private func binding() {
        _totalNetWorth.accept(provider.totalNetWorth)
        _totalIncomeValue.accept(provider.totalNetIncome)
        _currentDateRange.subscribe(onNext: { [weak self] range in
            self?.currentDateRangeIndex.accept(range.indexOfSelected())
        }).disposed(by: disposeBag)
    }
    
    func updateDateRange(value: ChartDateRange) {
        self._currentDateRange.accept(value)
    }
}
