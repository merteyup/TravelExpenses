//
//  CityListViewModel.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import Foundation
import NetworkingLayer

final class CityListViewModel: CityListViewModelProtocol {
    
    //MARK: - Variables
    weak var delegate: CityListViewModelDelegate?
    private let networkingService: NetworkingServiceProtocol
    private let coreDataService: CoreDataServiceProtocol
    private var cities: [CityPresentation] = []
    
    //MARK: - Init
    init(networkingService: NetworkingServiceProtocol,
         coreDataService: CoreDataServiceProtocol) {
        self.networkingService = networkingService
        self.coreDataService = coreDataService
    }
    
    //MARK: - Delegate Functions
    func loadCities() {
        notify(.setLoading(true))
        networkingService.fetchTopCities { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                let cityPresentations = success.cities.map {
                    cityResponse in CityPresentation(city: cityResponse
                    )}.sorted(by: {$0.name < $1.name})
                cities = cityPresentations
                saveCitiesToCoreData(cities: cities)
                notify(.showCityList(cityPresentations))
            case .failure:
                break
            }
            notify(.setLoading(false))
        }
    }
    
    func selectCity(at index: Int) {
        let city = cities[index]
        let viewModel = CityDetailViewModel(city: city)
        delegate?.navigate(to: .detail(viewModel))
    }
    
    private func notify(_ output: CityListViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
    
    //MARK: - Core Data
    private func saveCitiesToCoreData(cities: [CityPresentation]) {
        let cityModels = CityModel.from(cityPresentations: cities, context: managedContext)
        coreDataService.saveCitiesToCoreData(from: cityModels) { _ in }
    }
   
}
