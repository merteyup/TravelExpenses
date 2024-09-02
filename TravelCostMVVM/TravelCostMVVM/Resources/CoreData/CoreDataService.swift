//
//  CoreDataService.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 21.08.2024.
//

import CoreData
import Foundation
import Combine

protocol CoreDataServiceProtocol: AnyObject {
    func saveCitiesToCoreData(from cities: [CityPresentation]) -> AnyPublisher<Void, Error>
    func removeCitiesFromCoreData(_ remoteCities: [CityModel], existingCities: [CityModel]) -> AnyPublisher<Void, Error>
    func fetchCitiesFromCoreData() -> AnyPublisher<[CityModel], Error>
}

class CoreDataService: CoreDataServiceProtocol {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //MARK: - Core Data Operations
    
    func saveCitiesToCoreData(from cities: [CityPresentation]) -> AnyPublisher<Void, Error> {
        fetchCitiesFromCoreData()
            .flatMap { [weak self] existingCities -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Fail(error: NSError(domain: "", code: -1, userInfo: nil)).eraseToAnyPublisher()
                }

                let existingCitiesDictionary = self.createUniqueExistingCitiesDictionary(from: existingCities)
                
                for cityData in cities {
                    let cityID = Int(cityData.cityId ?? 123456)
                    if let existingCity = existingCitiesDictionary[cityID] {
                        let newCityData = CityModel(context: self.context)
                        newCityData.cityId = Int32(cityData.cityId ?? 123456)
                        newCityData.name = cityData.name
                        newCityData.countryName = cityData.countryName
                        newCityData.latitude = cityData.latitude ?? 0.0
                        newCityData.longitude = cityData.longitude ?? 0.0
                        newCityData.stateCode = cityData.stateCode
                        _ = self.updateCityOnCoreData(existingCity, with: newCityData)
                    } else {
                        let newCity = CityModel(context: self.context)
                        newCity.cityId = Int32(cityData.cityId ?? 123456)
                        newCity.name = cityData.name
                        newCity.countryName = cityData.countryName
                        newCity.latitude = cityData.latitude ?? 0.0
                        newCity.longitude = cityData.longitude ?? 0.0
                        newCity.stateCode = cityData.stateCode
                        self.saveContext(self.context)
                    }
                }
                return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    
    func removeCitiesFromCoreData(_ remoteCities: [CityModel], existingCities: [CityModel]) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { [weak self] promise in
                self?.context.perform {
                    guard let self = self else { return }
                    
                    let remoteCityIDs = Set(remoteCities.map { $0.cityId })
                    
                    let citiesToRemove = existingCities.filter { city in
                        !remoteCityIDs.contains(city.cityId)
                    }
                    
                    for city in citiesToRemove {
                        self.context.delete(city)
                    }
                    
                    self.saveContext(self.context)
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchCitiesFromCoreData() -> AnyPublisher<[CityModel], Error> {
        Deferred {
            Future { [weak self] promise in
                self?.context.performAndWait {
                    let cityFetchRequest: NSFetchRequest<CityModel> = CityModel.fetchRequest()
                    let sortByName = NSSortDescriptor(key: #keyPath(CityModel.name), ascending: true)
                    cityFetchRequest.sortDescriptors = [sortByName]
                    
                    do {
                        let results = try self?.context.fetch(cityFetchRequest)
                        promise(.success(results ?? []))
                        print("Results.count: \(String(describing: results?.count))")
                    } catch let error as NSError {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateCityOnCoreData(_ existingCity: CityModel, with newCityData: CityModel) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { [weak self] promise in
                self?.context.performAndWait {
                    var hasChanges = false
                    
                    if existingCity.name != newCityData.name {
                        existingCity.name = newCityData.name
                        hasChanges = true
                    }
                    
                    if existingCity.countryName != newCityData.countryName {
                        existingCity.countryName = newCityData.countryName
                        hasChanges = true
                    }
                    
                    if existingCity.latitude != newCityData.latitude {
                        existingCity.latitude = newCityData.latitude
                        hasChanges = true
                    }
                    
                    if existingCity.longitude != newCityData.longitude {
                        existingCity.longitude = newCityData.longitude
                        hasChanges = true
                    }
                    
                    if existingCity.stateCode != newCityData.stateCode {
                        existingCity.stateCode = newCityData.stateCode
                        hasChanges = true
                    }
                    
                    if hasChanges {
                        self?.saveContext(self!.context)
                        promise(.success(()))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}


//MARK: - SaveCitiesToCoreData Functions
extension CoreDataService {
    private func createUniqueExistingCitiesDictionary(from existingCities: [CityModel]) -> [Int: CityModel] {
        return Dictionary(
            grouping: existingCities,
            by: { Int($0.cityId) }
        ).compactMapValues { $0.first }
    }

    private func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
