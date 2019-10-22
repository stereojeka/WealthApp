//
//  OptionTableViewCell.swift
//  WealthApp
//
//  Created by Евгений Нименко on 10/20/19.
//  Copyright © 2019 Yevhenii Nimenko. All rights reserved.
//

import UIKit

class OptionTableViewCell: UITableViewCell, CellInizializable {
    
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(_ model: OptionProtocol, selected: Bool) {
        titleLabel.text = model.optionName
        checkmarkImageView.isHidden = !selected
    }
    
}
