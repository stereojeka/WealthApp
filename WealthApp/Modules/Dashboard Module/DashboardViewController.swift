//
//  DashboardViewController.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/20/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import RxCocoa
import RxSwift
import Charts

class DashboardViewController: UIViewController, StoryboardInitializable {
    
    @IBOutlet weak var totalNetWorthLabel: UILabel!
    @IBOutlet weak var incomeIconImageView: UIImageView!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var dataRangeLabel: UILabel!
    @IBOutlet weak var dataRangeChangeButton: UIButton!
    @IBOutlet weak var chartView: LineChartView!
    
    @IBOutlet weak var assetWithinLabel: UILabel!
    @IBOutlet weak var assetWithinIcon: UIImageView!
    
    @IBOutlet weak var assetExternalLabel: UILabel!
    @IBOutlet weak var assetExternalIcon: UIImageView!
    
    @IBOutlet weak var fixedIncomeLabel: UILabel!
    @IBOutlet weak var fixedIncomeIcon: UIImageView!
    
    @IBOutlet weak var totalsLabel: UILabel!
    @IBOutlet weak var totalsIcon: UIImageView!
    
    private let disposeBag = DisposeBag()
    
    var viewModel: DashboardViewModel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        binding()
    }
    
    private func setupUI() {
        setupNavigationBar()
        setupChartView()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.greyishBrownTwo
        ]
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationItem.title = "Dashboard"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icBell"), style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icSearch"), style: .plain, target: self, action: nil)
    }
    
    private func setupChartView() {
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        
        chartView.legend.form = .none
        
        chartView.leftAxis.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .regular)
        xAxis.labelTextColor = UIColor.brownGrey
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = 3600
        xAxis.valueFormatter = DateValueFormatter()
        
        let rightAxis = chartView.rightAxis
        rightAxis.drawAxisLineEnabled = false
        rightAxis.labelTextColor = .brownGrey
        rightAxis.granularityEnabled = false
        rightAxis.gridLineDashLengths = [5, 5]
        rightAxis.gridLineDashPhase = 1
        rightAxis.valueFormatter = LargeValueFormatter()
    }
    
    private func binding() {
        viewModel.totalNetWorth
            .drive(onNext: { [weak self] value in
                self?.totalNetWorthLabel.text = "£" + value.kmFormatted
            }).disposed(by: disposeBag)
        
        viewModel.totalIncomeValue
            .drive(onNext: { [weak self] value in
                self?.incomeIconImageView.image = UIImage(named: value >= 0 ? "icArrowUp" : "icArrowDown")
                self?.totalIncomeLabel.text = value.kmFormatted
            }).disposed(by: disposeBag)
        
        viewModel.assetsWithinStructure
        .drive(onNext: { [weak self] value in
            self?.assetWithinIcon.image = UIImage(named: value >= 0 ? "icArrowUp" : "icArrowDown")
            self?.assetWithinLabel.textColor = value >= 0 ? UIColor.darkishGreen : UIColor.darkCoral
            self?.assetWithinLabel.text = value.kmFormatted
        }).disposed(by: disposeBag)
        
        viewModel.assetsExternalToStructure
        .drive(onNext: { [weak self] value in
            self?.assetExternalIcon.image = UIImage(named: value >= 0 ? "icArrowUp" : "icArrowDown")
            self?.assetExternalLabel.textColor = value >= 0 ? UIColor.darkishGreen : UIColor.darkCoral
            self?.assetExternalLabel.text = value.kmFormatted
        }).disposed(by: disposeBag)
        
        viewModel.assetsFixedIncome
        .drive(onNext: { [weak self] value in
            self?.fixedIncomeIcon.image = UIImage(named: value >= 0 ? "icArrowUp" : "icArrowDown")
            self?.fixedIncomeLabel.textColor = value >= 0 ? UIColor.darkishGreen : UIColor.darkCoral
            self?.fixedIncomeLabel.text = value.kmFormatted
        }).disposed(by: disposeBag)
        
        viewModel.totalsIncome
        .drive(onNext: { [weak self] value in
            self?.totalsIcon.image = UIImage(named: value >= 0 ? "icArrowUp" : "icArrowDown")
            self?.totalsLabel.textColor = value >= 0 ? UIColor.darkishGreen : UIColor.darkCoral
            self?.totalsLabel.text = value.kmFormatted
        }).disposed(by: disposeBag)
        
        viewModel.currentDateRange
        .drive(onNext: { [weak self] value in
            self?.dataRangeLabel.text = value.shortcut
        }).disposed(by: disposeBag)
        
        dataRangeChangeButton
            .rx
            .tap
            .debounce(RxTimeInterval.milliseconds(30), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.showOptionSelectView(for: ChartDateRange.allCases, currentSelectedIndex: self.viewModel.currentDateRangeIndex.value, completion: { [weak self] selectedIndex in
                    let newRange = ChartDateRange(from: selectedIndex)
                    self?.viewModel.updateDateRange(value: newRange)
                    self?.updateChartGranularity(with: newRange)
                })
            }).disposed(by: disposeBag)
        
        viewModel.chartDataProvider.output
            .subscribe(onNext: { [weak self] output in
                self?.updateCharData(with: output)
            }).disposed(by: disposeBag)
    }
    
    private func updateChartGranularity(with period: ChartDateRange) {
        var granularity: Double
        
        switch period {
        case .oneDay:
            granularity = 3600
        case .oneWeek:
            granularity = 3600
        case .oneMonth:
            granularity = 3600 * 7
        case .oneQuarter:
            granularity = 3600 * 30
        case .sixMonth:
            granularity = 3600 * 30
        case .oneYear:
            granularity = 3600 * 60
        case .allTime:
            granularity = 3600 * 60
        }
        
        self.chartView.xAxis.granularity = granularity
    }
}

extension DashboardViewController: ChartViewDelegate {
    
    func updateCharData(with newData: [ChartDataEntry]) {
        let dataSet = LineChartDataSet(entries: newData, label: "")
        dataSet.drawCirclesEnabled = false
        dataSet.drawIconsEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.highlightEnabled = false
        dataSet.lineWidth = 2.0
        dataSet.setColor(NSUIColor(cgColor: UIColor.darkishPurple.cgColor))
        
        let gradientColors = [UIColor.darkishPinkTwo.cgColor,
                              UIColor.lipstick.withAlphaComponent(0).cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        dataSet.fillAlpha = 1
        dataSet.fill = Fill(linearGradient: gradient, angle: -90) //.linearGradient(gradient, angle: 90)
        dataSet.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
    }
    
}

extension DashboardViewController: OptionSelectRoute {
    
    func showOptionSelectView(for options: [OptionProtocol], currentSelectedIndex: Int, completion: ((Int) -> Void)?) {
        let viewController = OptionsSelectViewController.initFromStoryboard(name: "OptionsSelectView")
        viewController.dataSource = options
        viewController.currentSelectedIndex = currentSelectedIndex
        viewController.completion = completion
        
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }
}
