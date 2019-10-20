//
//  Message.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/20/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import Foundation

struct Message: Codable {
    
    let fromName: String
    let ccNames: [String]
    let toNames: [String]
    let messageDate: String
    let subject: String
    let description: String
    let importanceLevel: Int
    let isRead: Bool
    let isPinned: Bool
}
