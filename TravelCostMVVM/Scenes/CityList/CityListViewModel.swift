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
    private var cities: [City] = []
    
    init(service: NetworkingService) {
        self.service = service
    }

    func load() {
        notify(.setLoading(true))
        service.fetchTopCities { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                let cityPresentations = success.cities.map { city in
                    CityPresentation(city: city)
                }
                notify(.showCityList(cityPresentations))
            case .failure(let _):
                break
            }
            notify(.setLoading(false))
        }
    }
    
    private func notify(_ output: CityListViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
}
