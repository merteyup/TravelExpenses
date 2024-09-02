//
//  CityListViewModel.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import Foundation
import Combine
import NetworkingLayer

final class CityListViewModel: CityListViewModelProtocol {
    
    //MARK: - Variables
    weak var delegate: CityListViewModelDelegate?
    private let networkingService: NetworkingServiceProtocol
    private let coreDataService: CoreDataServiceProtocol
    private var cities: [CityPresentation] = []
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Init
    init(networkingService: NetworkingServiceProtocol,
         coreDataService: CoreDataServiceProtocol) {
        self.networkingService = networkingService
        self.coreDataService = coreDataService
    }
    
    //MARK: - Delegate Functions

    func loadCities() {
        notify(.setLoading(true))
        networkingService.fetch(from: .cities, responseType: CitiesResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self.fetchCitiesFromCoreData()
                    break
                }
                self.notify(.setLoading(false))
            }, receiveValue: { citiesResponse in
                self.cities = citiesResponse.cities.sorted(by: {
                    ($0.name ?? "") < ($1.name ?? "")
                })
                
                self.notify(.showCityList(self.cities))
                self.saveCitiesToCoreData(cities: self.cities)
            })
            .store(in: &cancellables)
    }
    
    func saveCitiesToCoreData(cities: [CityPresentation]) {
        coreDataService.saveCitiesToCoreData(from: cities)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self.fetchCitiesFromCoreData()
                }
            }, receiveValue: { _ in
                
            })
            .store(in: &cancellables)
    }
    
    func fetchCitiesFromCoreData() {
        coreDataService.fetchCitiesFromCoreData()
            .sink(receiveCompletion: { _ in }, receiveValue: { cities in
                if cities.count > 0 {
                    let cityPresentations = cities.compactMap { CityPresentation(cityModel: $0) }
                    self.notify(.showCityList(cityPresentations))
                } else {
                    self.notify(.showEmptyList("There's no cities found on remote or local database. Please try again later."))
                }
            })
            .store(in: &cancellables)
    }
    
    func selectCity(at index: Int) {
        let city = cities[index]
        let viewModel = CityDetailViewModel(city: city)
        delegate?.navigate(to: .detail(viewModel))
    }
    
    private func notify(_ output: CityListViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
    
}
