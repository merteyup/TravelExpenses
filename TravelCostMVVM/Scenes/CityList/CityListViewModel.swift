//
//  CityListViewModel.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import Foundation

final class CityListViewModel: CityListViewModelProtocol {
    
    weak var delegate: CityListViewModelDelegate?
    private let synchronizationService: SynchronizationService
    private var cities: [CityPresentation] = []
    
    init(synchronizationService: SynchronizationService) {
        self.synchronizationService = synchronizationService
    }
    
    func loadCities() {
        notify(.setLoading(true))
        synchronizationService.synchronizeData { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                let cityPresentations = success.map { cityResponse in
                    CityPresentation(cityModel: cityResponse)
                }.sorted(by: {$0.name < $1.name})
                cities = cityPresentations
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
}
