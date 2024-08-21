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
    private var isSearching = false
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
        viewModel.loadCities()
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
        cell.configure(with: city)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CityListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index: Int
        if isSearching {
            let filteredCity = filteredCities[indexPath.row]
            guard let originalIndex = originalIndex(for: filteredCity) else {
                return
            }
            index = originalIndex
        } else {
            index = indexPath.row
        }
        viewModel.selectCity(at: index)
    }
    private func originalIndex(for filteredCity: CityPresentation) -> Int? {
        return cities.firstIndex(where: { $0 == filteredCity })
    }
}

// MARK: - UISearchBarDelegate

extension CityListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        filterCities(for: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        filterCities(for: "")
        searchBar.resignFirstResponder()
    }
}

// MARK: - CityListViewModelDelegate

extension CityListViewController: CityListViewModelDelegate {
    func navigate(to route: CityListViewRoute) {
        switch route {
        case .detail(let cityDetailViewModelProtocol):
            let cityDetailViewController = CityDetailBuilder.make(viewModel: cityDetailViewModelProtocol)
            show(cityDetailViewController, sender: nil)
        }
    }
    
    func handleViewModelOutput(_ output: CityListViewModelOutput) {
        switch output {
        case .updateTitle(let string):
            self.title = string
        case .setLoading(let bool):
            bool ? view.showLoading() : view.hideLoading()
        case .showCityList(let cities):
            self.cities = cities
            tableView.reloadData()
        }
    }
}
