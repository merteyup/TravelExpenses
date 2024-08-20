//
//  CityListContracts.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import Foundation

protocol CityListViewModelProtocol: AnyObject {
    var delegate: CityListViewModelDelegate? { get set }
    func load()
   // func selectPodcast(at index: Int)
}

enum CityListViewModelOutput: Equatable {
    case updateTitle(String)
    case setLoading(Bool)
    case showCityList([CityPresentation])
}

protocol CityListViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: CityListViewModelOutput)
}
