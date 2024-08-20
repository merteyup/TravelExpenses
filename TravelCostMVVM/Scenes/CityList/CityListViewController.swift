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
    var cities: [CityPresentation] = [] {
        didSet {
            filteredCities = cities
        }
    }
    private var filteredCities: [CityPresentation] = []
    var viewModel: CityListViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        viewModel.load()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        title = "Cities"
        searchBar.placeholder = "Search Cities"
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        tableView.register(CityCell.self, forCellReuseIdentifier: "CityCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .red
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func filterCities(for searchText: String) {
        if searchText.isEmpty {
            filteredCities = cities
        } else {
            filteredCities = cities.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension CityListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
        let city = filteredCities[indexPath.row]
        cell.backgroundColor = .yellow
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.countryName
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CityListViewController: UITableViewDelegate {
    // Handle row selection and other delegate methods if needed
}

// MARK: - UISearchBarDelegate

extension CityListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterCities(for: searchText)
    }
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
