//
//  DashboardViewController.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/20/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import RxCocoa
import RxSwift

class DashboardViewController: UIViewController, StoryboardInitializable {
    
    @IBOutlet weak var totalNetWorthLabel: UILabel!
    @IBOutlet weak var incomeIconImageView: UIImageView!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var dataRangeLabel: UILabel!
    @IBOutlet weak var dataRangeChangeButton: UIButton!
    
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
                })
            }).disposed(by: disposeBag)
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
