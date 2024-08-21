//
//  CityListViewModel.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import Foundation
import NetworkingLayer

final class CityListViewModel: CityListViewModelProtocol {
    
    weak var delegate: CityListViewModelDelegate?
    private let service: NetworkingService
    private var cities: [CityPresentation] = []
    
    init(service: NetworkingService) {
        self.service = service
    }

    func loadCities() {
        notify(.setLoading(true))
        service.fetchTopCities { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                let cityPresentations = success.cities.map { city in
                    CityPresentation(city: city)
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
