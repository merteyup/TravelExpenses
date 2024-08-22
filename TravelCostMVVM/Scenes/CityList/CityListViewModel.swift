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
    private let networkingService: NetworkingServiceProtocol
    private let coreDataService: CoreDataServiceProtocol
    private var cities: [CityPresentation] = []
    
    init(networkingService: NetworkingServiceProtocol, 
         coreDataService: CoreDataServiceProtocol) {
        self.networkingService = networkingService
        self.coreDataService = coreDataService
    }
    
    func loadCities() {
        notify(.setLoading(true))
        networkingService.fetchTopCities { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                saveCitiesToCoreData(cities: success)
                let cityPresentations = success.cities.map {
                    cityResponse in CityPresentation(city: cityResponse
                    )}.sorted(by: {$0.name < $1.name})
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
    
    private func saveCitiesToCoreData(cities: CitiesResponse) {
        let cityModels = convertCitiesResponseToCityModels(cities)
        coreDataService.saveCitiesToCoreData(from: cityModels) { result in
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                break
            }
        }
    }
    
    private func convertCitiesResponseToCityModels(_ response: CitiesResponse) -> [CityModel] {
        return response.cities.map { city in
            let cityModel = CityModel(context: app.coreData.context)
            cityModel.cityId = Int32(city.cityId)
            cityModel.name = city.cityName
            cityModel.countryName = city.countryName
            cityModel.latitude = city.lat
            cityModel.longitude = city.lng
            cityModel.stateCode = city.stateCode
            return cityModel
        }
    }
}
