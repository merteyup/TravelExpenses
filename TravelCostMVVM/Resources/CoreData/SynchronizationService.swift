//
//  SynchronizationService.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 21.08.2024.
//

import Foundation
import NetworkingLayer

class SynchronizationService {
    private let networkingService: NetworkingService
    private let coreDataService: CoreDataService
    
    init(networkingService: NetworkingService, coreDataService: CoreDataService) {
        self.networkingService = networkingService
        self.coreDataService = coreDataService
    }
    
    func synchronizeData(completion: @escaping (Result<[CityModel], Error>) -> Void) {
        networkingService.fetchTopCities { [weak self] result in
            guard let self else {
                completion(.failure(NSError(domain: "SynchronizationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }
            
            let coreDataCities = coreDataService.fetchCitiesFromCoreData() ?? []
            
            switch result {
            case .success(let remoteCitiesResponse):
                let remoteCities = convertCitiesResponseToCityModels(remoteCitiesResponse)
                
                let newCities = findNewCities(coreDataCities: coreDataCities, remoteCities: remoteCities)
                
                coreDataService.saveCities(from: newCities) { result in
                    switch result {
                    case .success:
                        completion(.success(remoteCities))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                if !coreDataCities.isEmpty {
                    completion(.success(coreDataCities))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func findDuplicates(coreDataCities: [CityModel], remoteCities: [CityModel]) -> ([CityModel], [CityModel]) {
        let coreDataCityDict = Dictionary(uniqueKeysWithValues: coreDataCities.map { ($0.cityId, $0) })
        let remoteCityDict = Dictionary(uniqueKeysWithValues: remoteCities.map { ($0.cityId, $0) })
        
        let duplicateIds = Set(coreDataCityDict.keys).intersection(Set(remoteCityDict.keys))
        
        let duplicateCoreDataCities = duplicateIds.compactMap { coreDataCityDict[$0] }
        let duplicateRemoteCities = duplicateIds.compactMap { remoteCityDict[$0] }
        
        return (duplicateCoreDataCities, duplicateRemoteCities)
    }
    
    private func findNewCities(coreDataCities: [CityModel], remoteCities: [CityModel]) -> [CityModel] {
        var seenCityIds = Set<Int32>()
        var uniqueCoreDataCities = [CityModel]()
        
        for city in coreDataCities {
            if !seenCityIds.contains(city.cityId) {
                seenCityIds.insert(city.cityId)
                uniqueCoreDataCities.append(city)
            }
        }
        
        let coreDataCityDict = Dictionary(uniqueKeysWithValues: uniqueCoreDataCities.map { ($0.cityId, $0) })
        
        let newCities = remoteCities.filter { city in
            coreDataCityDict[city.cityId] == nil
        }
        
        return newCities
    }

    private func processRemoteCities(_ remoteCities: [CityModel], coreDataCitiesDict: [Int32: CityModel]) -> ([CityModel], [CityModel]) {
        var updatedCities = [CityModel]()
        var citiesToAdd = [CityModel]()
        
        for remoteCity in remoteCities {
            if let coreDataCity = coreDataCitiesDict[remoteCity.cityId] {
                if !isCityEqual(coreDataCity, remoteCity) {
                    updateCity(coreDataCity, with: remoteCity)
                    updatedCities.append(coreDataCity)
                }
            } else {
                let newCity = createNewCity(from: remoteCity)
                citiesToAdd.append(newCity)
            }
        }
        
        return (updatedCities, citiesToAdd)
    }

    private func updateCity(_ coreDataCity: CityModel, with remoteCity: CityModel) {
        coreDataCity.name = remoteCity.name
        coreDataCity.countryName = remoteCity.countryName
        coreDataCity.latitude = remoteCity.latitude
        coreDataCity.longitude = remoteCity.longitude
        coreDataCity.stateCode = remoteCity.stateCode
    }

    private func createNewCity(from remoteCity: CityModel) -> CityModel {
        let newCity = CityModel(context: coreDataService.context)
        newCity.cityId = remoteCity.cityId
        newCity.name = remoteCity.name
        newCity.countryName = remoteCity.countryName
        newCity.latitude = remoteCity.latitude
        newCity.longitude = remoteCity.longitude
        newCity.stateCode = remoteCity.stateCode
        return newCity
    }

    private func isCityEqual(_ coreDataCity: CityModel, _ remoteCity: CityModel) -> Bool {
        return coreDataCity.name == remoteCity.name &&
               coreDataCity.countryName == remoteCity.countryName &&
               coreDataCity.latitude == remoteCity.latitude &&
               coreDataCity.longitude == remoteCity.longitude &&
               coreDataCity.stateCode == remoteCity.stateCode
    }

    private func convertCitiesResponseToCityModels(_ response: CitiesResponse) -> [CityModel] {
           return response.cities.map { city in
               let cityModel = CityModel(context: coreDataService.context)
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
