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
    
    let messages = BehaviorRelay<[Message]>(value: [])
    
    let shownMessages = BehaviorRelay<[Message]>(value: [])
    
    init(provider: DataProvider) {
        self.provider = provider
    }
    
    func onViewReady() {
        let messages = provider.client?.inboxMessages.sorted(by: { (first, second) -> Bool in
            if !first.isRead && !second.isRead {
                return first.importanceLevel > second.importanceLevel
            } else if first.isRead {
                return false
            } else {
                return true
            }
        })
        
        self.messages.accept(messages ?? [])
        self.shownMessages.accept(messages ?? [])
    }
    
}
