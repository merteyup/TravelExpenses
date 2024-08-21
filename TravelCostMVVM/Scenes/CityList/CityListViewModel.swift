//
//  CityListViewModel.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import Foundation
import NetworkingLayer
import CoreData

final class CityListViewModel: CityListViewModelProtocol {
    
    weak var delegate: CityListViewModelDelegate?
    private let service: NetworkingService
    private var cities: [CityPresentation] = []
    
    init(service: NetworkingService) {
        self.service = service
    }
    
    func loadCities() {
        notify(.setLoading(true))
        service.fetchTopCities { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                let cityPresentations = success.cities.map { cityResponse in
                    CityPresentation(city: cityResponse)
                }.sorted(by: {$0.name < $1.name})
                cities = cityPresentations
                saveCities(from: success)
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
    
    
    //MARK: - Core Data Operations
    
    func saveCities(from response: CitiesResponse) {
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        for cityData in response.cities {
            let city = CityModel(context: managedContext)
            city.name = cityData.cityName
            city.countryName = cityData.countryName
        }
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }
    
    func getCitiesFromCoreData() {
        let cityFetchRequest: NSFetchRequest<CityModel> = CityModel.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(CityModel.name), ascending: true)
        cityFetchRequest.sortDescriptors = [sortByName]
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(cityFetchRequest)
            let cityPresentations = results.map { cityResponse in
                CityPresentation(cityModel: cityResponse)
            }.sorted(by: {$0.name < $1.name})
            notify(.showCityList(cityPresentations))
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
}
