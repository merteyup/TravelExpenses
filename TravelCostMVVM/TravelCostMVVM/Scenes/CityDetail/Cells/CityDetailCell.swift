//
//  CityDetailCell.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 21.08.2024.
//

import UIKit
import SnapKit

class CityDetailCell: UITableViewCell {
    
    // MARK: - Properties
    private let stackView = UIStackView()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .yellow
        setupView()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(16)
        }
    }
    
    // MARK: - Public Methods
    
    func configure(withTitles titles: [PricePresentation]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for title in titles {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14)
            label.textColor = .black
            label.numberOfLines = 0
            label.text = title.itemName
            stackView.addArrangedSubview(label)
        }
    }
}
