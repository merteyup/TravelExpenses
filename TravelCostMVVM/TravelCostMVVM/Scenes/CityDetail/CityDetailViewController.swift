//
//  CityDetailViewController.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import UIKit
import SnapKit

class CityDetailViewController: UIViewController, CityDetailViewModelDelegate {
    
    var viewModel: CityDetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    private let tableView = UITableView()
    private var presentation: CityDetailPresentation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        viewModel.load()
        setupConstraints()
    }
    
    func showDetail(_ presentation: CityDetailPresentation) {
        self.presentation = presentation
        tableView.dataSource = self
        tableView.register(EmptyCell.self, forCellReuseIdentifier: "EmptyCell")
        tableView.register(CityDetailCell.self, forCellReuseIdentifier: "CityDetailCell")
        tableView.register(CityDetailHeaderCell.self, forCellReuseIdentifier: "CityDetailHeaderCell")
        tableView.backgroundColor = .red
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func handleViewModelOutput(_ output: CityDetailViewModelOutput) {
        switch output {
        case .updateTitle(let string):
            title = string
        case .setLoading(let bool):
            bool ? view.showLoading() : view.hideLoading()
        case .showPriceDetails(let cityDetailPresentation):
            tableView.reloadData()
            break
        }
    }
    
}

extension CityDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityDetailCell", for: indexPath) as! CityDetailCell
        
        if let prices = presentation?.prices {
            cell.configure(withTitles: prices)
        }
        
        return cell
        
        
     //   if let count = presentation?.prices?.count {
     //       let cell = tableView.dequeueReusableCell(withIdentifier: "CityDetailCell", for: indexPath) as! CityDetailCell
     //     //  cell.configure(with: city)
     //       return cell
     //   } else {
     //       let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
     //
     //       return emptyCell
     //   }
    }
    
}
