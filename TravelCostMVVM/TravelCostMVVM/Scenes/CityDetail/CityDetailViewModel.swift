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
        
        service.fetch(from: .prices(cityName, countryName), responseType: PriceResponse.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                break
            }
        }

    }
    
    private func notify(_ output: CityDetailViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
}
