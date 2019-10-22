//
//  OptionsSelectViewController.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/20/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import RxCocoa
import RxSwift

class OptionsSelectViewController: UIViewController, StoryboardInitializable {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    var dataSource: [OptionProtocol] = []
    
    var completion: ((Int) -> Void)?
    
    var currentSelectedIndex: Int = 0 {
        didSet {
            guard self.tableView != nil else { return }
            self.tableView.reloadRows(at: [IndexPath(row: oldValue, section: 0), IndexPath(row: currentSelectedIndex, section: 0)], with: .automatic)
        }
    }
    
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
        tableView.register(OptionTableViewCell.nib, forCellReuseIdentifier: OptionTableViewCell.identifier)
        tableView.rowHeight = 44.0
        tableView.contentInset = UIEdgeInsets(top: 32.0, left: 0, bottom: 0, right: 0)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.greyishBrownTwo
        ]
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationItem.title = "Date Range"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onDoneButtonAction(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = .lipstick
    }
    
    private func binding() {
        Observable
            .of(dataSource)
            .bind(to: tableView.rx.items(cellIdentifier: OptionTableViewCell.identifier, cellType: OptionTableViewCell.self)) { [weak self] index, model, cell in
                guard let self = self else { return }
                cell.bind(model,selected: self.currentSelectedIndex == index)
                cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        tableView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.currentSelectedIndex = indexPath.row
            }).disposed(by: disposeBag)
    }
    
    @objc
    func onDoneButtonAction(_ sender: UIButton) {
        self.completion?(self.currentSelectedIndex)
        self.dismiss(animated: true, completion: nil)
    }
}
