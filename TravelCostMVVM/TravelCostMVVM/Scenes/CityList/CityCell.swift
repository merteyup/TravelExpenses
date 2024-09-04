//
//  CityCell.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import UIKit

class CityCell: UITableViewCell {
    
    static let cellIdentifier = "CityCell"
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()
    
    private let countryNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cityNameLabel.text = nil
        countryNameLabel.text = nil
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(countryNameLabel)
    }
    
    private func setupConstraints() {
        cityNameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(15)
        }
        
        countryNameLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview().inset(15)
        }
    }
    
    // MARK: - Configure Cell
    func configure(with city: CityPresentation) {
        cityNameLabel.text = city.name
        countryNameLabel.text = city.countryName
    }
}
