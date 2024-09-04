//
//  EmptyCell.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 21.08.2024.
//

import UIKit

class EmptyCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with text: String) {
        self.textLabel?.numberOfLines = 0
        self.textLabel?.textAlignment = .center
        self.textLabel?.text = text
    }

}
