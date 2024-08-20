//
//  CityListViewController.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import UIKit
import SnapKit

final class CityListViewController: UIViewController {
    
    // MARK: - Properties
    
    var city = CityPresentation(title: "Istanbul")
    var cities: [CityPresentation] = []
    var viewModel: CityListViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    private let tableView = UITableView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cities.append(city)
        setupView()
        setupConstraints()
        bindViewModel()
      //  viewModel.load()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        title = "Cities"
        tableView.register(CityCell.self, forCellReuseIdentifier: "CityCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .red
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        // Setup any additional bindings if necessary
    }
}

// MARK: - UITableViewDataSource

extension CityListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
        let city = cities[indexPath.row]
        cell.backgroundColor = .yellow
        cell.textLabel?.text = city.name
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CityListViewController: UITableViewDelegate {
    // Handle row selection and other delegate methods if needed
}

// MARK: - CityListViewModelDelegate

extension CityListViewController: CityListViewModelDelegate {
    func handleViewModelOutput(_ output: CityListViewModelOutput) {
        switch output {
        case .updateTitle(let string):
            self.title = string
        case .setLoading(let bool):
            print(bool)
        case .showCityList(let cities):
            self.cities = cities
            tableView.reloadData()
        }
    }
}
