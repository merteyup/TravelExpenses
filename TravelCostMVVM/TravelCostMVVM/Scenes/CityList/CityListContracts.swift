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

enum CityListViewModelOutput {
    case updateTitle(String)
    case setLoading(Bool)
    case showCityList([CityPresentation])
    case showEmptyList(String)
}

enum CityListViewRoute {
    case detail(CityDetailViewModelProtocol)
}


protocol CityListViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: CityListViewModelOutput)
    func navigate(to route: CityListViewRoute)
}
