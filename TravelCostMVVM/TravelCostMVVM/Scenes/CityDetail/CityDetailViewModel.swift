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
    
    func load() { }
    
    private func notify(_ output: CityDetailViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
}
