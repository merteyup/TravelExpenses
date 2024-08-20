//
//  CityCell.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import UIKit

class CityCell: UITableViewCell {
    
    static let cellIdentifier = "CityCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .blue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
