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
    private var cities: [City] = []
    private var cancellables = Set<AnyCancellable>()
    private let apiLimitExceededSubject = PassthroughSubject<Void, Never>()
  
    
    //MARK: - Init
    init(networkingService: NetworkingServiceProtocol,
         coreDataService: CoreDataServiceProtocol) {
        self.networkingService = networkingService
        self.coreDataService = coreDataService
    }
    
    //MARK: - Delegate Functions

    func loadCities() {
        notify(.updateTitle("Cities"))
        notify(.setLoading(true))
        networkingService.fetch(from: .cities, responseType: CitiesResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.fetchCitiesFromCoreData(according: error)
                }
                self.notify(.setLoading(false))
            }, receiveValue: { citiesResponse in
                
                self.cities = citiesResponse.cities.compactMap { City(presentation: $0) }

                self.notify(.showCityList(citiesResponse.cities.sorted { $0.name ?? "" < $1.name ?? "" }))
                self.saveCitiesToCoreData(cities: citiesResponse.cities)
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
    
    func fetchCitiesFromCoreData(according error: Error? = nil) {
        coreDataService.fetchCitiesFromCoreData()
            .sink(receiveCompletion: { _ in }, receiveValue: { cities in
                guard !cities.isEmpty else {
                    self.handleEmptyCities(error: error)
                    return
                }

                let cityPresentations = cities.map { CityPresentation(cityModel: $0) }
                self.cities = cityPresentations.compactMap { City(presentation: $0) }
                self.notify(.showCityList(cityPresentations))
            })
            .store(in: &cancellables)
    }

    private func handleEmptyCities(error: Error?) {
        if let customError = error as? Errors, customError == .apiLimitExceeded {
            self.notify(.apiLimitExceeded("Maximum API usage limit is exceeded. Please try again later."))
        } else {
            self.notify(.showEmptyList("There are no cities found on the remote or local database. Please try again later."))
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
    
}
