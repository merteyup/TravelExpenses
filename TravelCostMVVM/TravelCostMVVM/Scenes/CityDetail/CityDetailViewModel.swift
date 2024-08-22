//
//  CityDetailViewModel.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import Foundation
import NetworkingLayer

final class CityDetailViewModel: CityDetailViewModelProtocol {
    
    var delegate: CityDetailViewModelDelegate?
    var city: CityPresentation?
    let service = NetworkingService()
    
    init(delegate: CityDetailViewModelDelegate? = nil, city: CityPresentation? = nil) {
        self.delegate = delegate
        self.city = city
    }
    
    
    
    func load() {
        guard let cityName = city?.name,
              let countryName = city?.countryName else { return }
        notify(.setLoading(true))
        service.fetchPricesBy(city: cityName, country: countryName) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                let cityDetailPresentation = CityDetailPresentation(from: success)
                notify(.showPriceDetails(cityDetailPresentation))
                break
            case .failure(let failure):
                break
            }
            notify(.setLoading(false))
        }
    }
    
    private func notify(_ output: CityDetailViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
}
