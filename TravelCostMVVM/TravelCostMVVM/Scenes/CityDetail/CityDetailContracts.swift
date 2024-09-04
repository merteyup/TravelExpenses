//
//  CityDetailContracts.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import Foundation

protocol CityDetailViewModelProtocol: AnyObject {
    var delegate : CityDetailViewModelDelegate? {get set}
    func load()
}

enum CityDetailViewModelOutput: Equatable {
    case updateTitle(String)
    case setLoading(Bool)
    case showPriceDetails(CityDetailPresentation)
    case apiLimitExceeded(String)
}


protocol CityDetailViewModelDelegate {
    func showDetail(_ presentation: CityDetailPresentation)
    func handleViewModelOutput(_ output: CityDetailViewModelOutput)
}
