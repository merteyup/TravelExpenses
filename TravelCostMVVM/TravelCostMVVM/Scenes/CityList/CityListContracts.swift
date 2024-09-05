//
//  CityListContracts.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import Foundation

protocol CityListViewModelProtocol: AnyObject {
    var delegate: CityListViewModelDelegate? { get set }
    func loadCities()
    func selectCity(at index: Int)
}

enum CityListViewModelOutput: Equatable {
    case updateTitle(String)
    case setLoading(Bool)
    case showCityList([CityPresentation])
    case showEmptyList(String)
    case apiLimitExceeded(String)
    
    static func == (lhs: CityListViewModelOutput, rhs: CityListViewModelOutput) -> Bool {
        switch (lhs, rhs) {
        case (.updateTitle(let leftTitle), .updateTitle(let rightTitle)):
            return leftTitle == rightTitle
        case (.setLoading(let leftLoading), .setLoading(let rightLoading)):
            return leftLoading == rightLoading
        case (.showCityList(let leftCities), .showCityList(let rightCities)):
            return leftCities == rightCities
        case (.showEmptyList(let leftMessage), .showEmptyList(let rightMessage)):
            return leftMessage == rightMessage
        case (.apiLimitExceeded(let leftMessage), .apiLimitExceeded(let rightMessage)):
            return leftMessage == rightMessage
        default:
            return false
        }
    }
}

enum CityListViewRoute {
    case detail(CityDetailViewModelProtocol)
}


protocol CityListViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: CityListViewModelOutput)
    func navigate(to route: CityListViewRoute)
}
