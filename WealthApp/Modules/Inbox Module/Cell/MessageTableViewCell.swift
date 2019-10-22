//
//  MessageTableViewCell.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/22/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell, CellInizializable {
    
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var fromNameLabel: UILabel!
    @IBOutlet weak var messageDateLabel: UILabel!
    @IBOutlet weak var newMarkButton: UIButton!
    @IBOutlet weak var messageTitleLabel: UILabel!
    @IBOutlet weak var messageDescrioption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarView.layer.cornerRadius = self.avatarView.bounds.width / 2
        self.avatarView.layer.masksToBounds = true
    }
    
    func bind(model: Message) {
        newMarkButton.isHidden = model.isRead
        fromNameLabel.text = model.fromName
        messageDateLabel.text = model.messageDate
        messageTitleLabel.text = model.subject
        messageDescrioption.text = model.description
    }
    
}
