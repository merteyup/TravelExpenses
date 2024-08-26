//
//  CoreDataService.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 21.08.2024.
//

import CoreData
import Foundation

protocol CoreDataServiceProtocol: AnyObject {
    func saveCitiesToCoreData(from cities: [CityModel], completion: @escaping (Result<Void, Error>) -> Void)
    func removeCitiesFromCoreData(_ remoteCities: [CityModel], existingCities: [CityModel], completion: @escaping (Result<Void, Error>) -> Void)
    func fetchCitiesFromCoreData() -> [CityModel]?
  //  func updateCityOnCoreData(_ existingCity: CityModel, with newCityData: CityModel)
}

class CoreDataService: CoreDataServiceProtocol {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //MARK: - Core Data Operations
    
    func saveCitiesToCoreData(from cities: [CityModel], completion: @escaping (Result<Void, Error>) -> Void) {
        let managedContext = self.context
        let existingCities = fetchCitiesFromCoreData()
        
        let existingCitiesDictionary = createUniqueExistingCitiesDictionary(from: existingCities ?? [])
        
        for cityData in cities {
            let cityID = Int(cityData.cityId)
            if let existingCity = existingCitiesDictionary[cityID] {
                updateCityOnCoreData(existingCity, with: cityData)
            } else {
                let newCity = CityModel(context: managedContext)
                newCity.cityId = cityData.cityId
                newCity.name = cityData.name
                newCity.countryName = cityData.countryName
                newCity.latitude = cityData.latitude
                newCity.longitude = cityData.longitude
                newCity.stateCode = cityData.stateCode
            }
        }
        
        guard let existingCities = existingCities,
              existingCities.count != cities.count else { return }
        removeCitiesFromCoreData(cities, existingCities: existingCities) { _ in }
    }
    
    
    func removeCitiesFromCoreData(_ remoteCities: [CityModel], existingCities: [CityModel], completion: @escaping (Result<Void, Error>) -> Void) {
        let managedContext = self.context
        
        let remoteCityIDs = Set(remoteCities.map { $0.cityId })
        
        let citiesToRemove = existingCities.filter { city in
            !remoteCityIDs.contains(city.cityId)
        }
        
        for city in citiesToRemove {
            managedContext.delete(city)
        }
        
        do {
            try managedContext.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchCitiesFromCoreData() -> [CityModel]? {
        let cityFetchRequest: NSFetchRequest<CityModel> = CityModel.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(CityModel.name), ascending: true)
        cityFetchRequest.sortDescriptors = [sortByName]
        do {
            let results = try context.fetch(cityFetchRequest)
            return results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
            return []
        }
    }
    
    func updateCityOnCoreData(_ existingCity: CityModel, with newCityData: CityModel) {
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
            do {
                try context.save()
            } catch {
                print("Failed to save updated city: \(error)")
            }
        }
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

    private func saveContext(_ context: NSManagedObjectContext, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
