//
//  InboxViewModel.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/22/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import RxCocoa
import RxSwift

class InboxViewModel {
    
    let provider: DataProvider
    
    let dataSource = BehaviorRelay<[Message]>(value: [])
    
    init(provider: DataProvider) {
        self.provider = provider
    }
    
    func onViewReady() {
        dataSource.accept(provider.client?.inboxMessages ?? [])
    }
    
}
