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
    func removeCitiesFromCoreData(_ cities: [CityModel], completion: @escaping (Result<Void, Error>) -> Void)
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
        let existingCities = fetchExistingCities()
        
        let existingCitiesDictionary = createUniqueExistingCitiesDictionary(from: existingCities)
        
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
        

        let existingCityKeys = Set(existingCitiesDictionary.keys)
        let cityIds = Set(cities.map { Int($0.cityId) })
        let idsToRemove = existingCityKeys.subtracting(cityIds)
        removeOldCities(withIDs: idsToRemove, from: existingCitiesDictionary, managedContext: managedContext)
        
        saveContext(managedContext, completion: completion)
    }
    
    
    func removeCitiesFromCoreData(_ cities: [CityModel], completion: @escaping (Result<Void, Error>) -> Void) {
        let managedContext = self.context
        let cityIDsToRemove = Set(cities.map { $0.cityId })
        
        let fetchRequest: NSFetchRequest<CityModel> = CityModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cityId IN %@", cityIDsToRemove)
        
        do {
            let citiesToRemove = try managedContext.fetch(fetchRequest)
            for city in citiesToRemove {
                managedContext.delete(city)
            }
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
    private func fetchExistingCities() -> [CityModel] {
        let cityFetchRequest: NSFetchRequest<CityModel> = CityModel.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(CityModel.name), ascending: true)
        cityFetchRequest.sortDescriptors = [sortByName]
        do {
            return try context.fetch(cityFetchRequest)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
            return []
        }
    }

    private func createUniqueExistingCitiesDictionary(from existingCities: [CityModel]) -> [Int: CityModel] {
        return Dictionary(
            grouping: existingCities,
            by: { Int($0.cityId) }
        ).compactMapValues { $0.first }
    }

    private func processIncomingCities(_ cities: [CityModel], uniqueExistingCities: [Int: CityModel], managedContext: NSManagedObjectContext) -> Set<Int> {
        var idsToRemove = Set(uniqueExistingCities.keys)
        
        for cityData in cities {
            if let existingCity = uniqueExistingCities[Int(cityData.cityId)] {
             //   updateCityOnCoreData(existingCity, with: cityData)
                idsToRemove.remove(Dictionary<Int, CityModel>.Keys.Element(cityData.cityId))
            } else {
                let city = CityModel(context: managedContext)
                city.cityId = cityData.cityId
                city.name = cityData.name
                city.countryName = cityData.countryName
                city.latitude = cityData.latitude
                city.longitude = cityData.longitude
                city.stateCode = cityData.stateCode
            }
        }
        return idsToRemove
    }

    private func removeOldCities(withIDs idsToRemove: Set<Int>, from uniqueExistingCities: [Int: CityModel], managedContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<CityModel> = CityModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cityId IN %@", idsToRemove)
        
        do {
            let citiesToRemove = try managedContext.fetch(fetchRequest)
            for city in citiesToRemove {
                managedContext.delete(city)
            }
            try managedContext.save()
        } catch {
            print("Error removing cities: \(error)")
        }
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
