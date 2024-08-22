//
//  CityDetailHeaderCell.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 21.08.2024.
//

import UIKit
import SnapKit

class CityDetailHeaderCell: UITableViewCell {

    // MARK: - Properties
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .black
        
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .darkGray
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
    }

    // MARK: - Public Methods
    func configure(withTitle title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
