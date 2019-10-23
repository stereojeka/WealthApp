//
//  InboxViewController.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/22/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import RxCocoa
import RxSwift

class InboxViewController: UIViewController, StoryboardInitializable {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    var viewModel: InboxViewModel!
    
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
        setupTable()
        hideKeyboardWhenTappedAround()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.greyishBrownTwo
        ]
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationItem.title = "Inbox"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icEdit"), style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(onFilterButtonAction))
    }
    
    private func setupTable() {
        tableView.separatorStyle = .none
        tableView.rowHeight = 121.0
        tableView.register(MessageTableViewCell.nib, forCellReuseIdentifier: MessageTableViewCell.identifier)
    }
    
    private func binding() {
        
        viewModel.shownMessages.bind(to: tableView.rx.items(cellIdentifier: MessageTableViewCell.identifier, cellType: MessageTableViewCell.self)) { _, model, cell in
            cell.bind(model: model)
        }.disposed(by: disposeBag)
        
        searchBar
            .rx
            .text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                guard let self = self else { return }
                if query.isEmpty {
                    self.viewModel.shownMessages.accept(self.viewModel.messages.value)
                } else {
                    let filteredMessages = self.viewModel.messages.value.filter {
                        $0.subject.lowercased().hasPrefix(query.lowercased()) || $0.description.lowercased().hasPrefix(query.lowercased())
                    }
                    self.viewModel.shownMessages.accept(filteredMessages)
                }
            }).disposed(by: disposeBag)
        
        viewModel.onViewReady()
    }
    
    @objc
    func onFilterButtonAction() {
        
    }
}
