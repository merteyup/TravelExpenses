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
        self.selectionStyle = .none
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        stackView.axis = .vertical
        stackView.spacing = 12
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

            let itemNameLabel = UILabel()
            itemNameLabel.font = .boldSystemFont(ofSize: 16)
            itemNameLabel.textColor = .black
            itemNameLabel.numberOfLines = 0
            itemNameLabel.text = title.itemName
            stackView.addArrangedSubview(itemNameLabel)

            let valuesLabel = UILabel()
            valuesLabel.font = .systemFont(ofSize: 14)
            valuesLabel.textColor = .darkGray
            valuesLabel.numberOfLines = 0
            valuesLabel.text = formatValues(for: title)
            stackView.addArrangedSubview(valuesLabel)
            
            let separator = UIView()
            stackView.addArrangedSubview(separator)
        }
    }
    
    private func formatValues(for title: PricePresentation) -> String {
        var values = [String]()
        
        if let min = title.min {
            values.append("Min: \(min)")
        }
        if let avg = title.avg {
            values.append("Avg: \(avg)")
        }
        if let max = title.max {
            values.append("Max: \(max)")
        }
        
        if let currencyCode = title.currencyCode {
            values.append(" \(currencyCode)")
        }
        
        return values.joined(separator: " | ")
    }
}
