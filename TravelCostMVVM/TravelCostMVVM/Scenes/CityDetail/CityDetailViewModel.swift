//
//  CityDetailViewModel.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import Foundation
import NetworkingLayer
import Combine

final class CityDetailViewModel: CityDetailViewModelProtocol {
    
    var delegate: CityDetailViewModelDelegate?
    var presentation: CityDetailPresentation
    let service: NetworkingServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(delegate: CityDetailViewModelDelegate? = nil, city: City, service: NetworkingServiceProtocol = NetworkingService()) {
        self.delegate = delegate
        self.presentation = CityDetailPresentation(city: city, cityDetails: nil)
        self.service = service
        fetchCityDetails(city: city)
    }
    
    func load() {
        delegate?.showDetail(presentation)
    }
    
    private func fetchCityDetails(city: City) {
        service.fetch(from: .prices(city.cityName, city.countryName), responseType: PriceResponse.CityDetails.self)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let _):
                    break
                }
            }, receiveValue: { [weak self] cityDetails in
                guard let self = self else { return }
                self.presentation = CityDetailPresentation(city: city, cityDetails: cityDetails)
                self.delegate?.showDetail(self.presentation)
                notify(.showPriceDetails(presentation))
            })
            .store(in: &cancellables)
    }
    
    private func notify(_ output: CityDetailViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
}
