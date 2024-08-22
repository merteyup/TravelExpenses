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
    func updateCityOnCoreData(_ existingCity: CityModel, with newCityData: CityModel)
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
        let uniqueExistingCities = createUniqueExistingCitiesDictionary(from: existingCities)
        let idsToRemove = processIncomingCities(cities, uniqueExistingCities: uniqueExistingCities, managedContext: managedContext)
        removeOldCities(withIDs: idsToRemove, from: uniqueExistingCities, managedContext: managedContext)
        saveContext(managedContext, completion: completion)
    }

    
    func removeCitiesFromCoreData(_ cities: [CityModel], completion: @escaping (Result<Void, Error>) -> Void) {
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        
        let fetchRequest: NSFetchRequest<CityModel> = CityModel.fetchRequest()
        do {
            let allCities = try managedContext.fetch(fetchRequest)
            for city in allCities where cities.contains(where: { $0.cityId == city.cityId }) {
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
            return nil
        }
    }
    
    func updateCityOnCoreData(_ existingCity: CityModel, with newCityData: CityModel) {
        existingCity.name = newCityData.name
        existingCity.countryName = newCityData.countryName
        existingCity.latitude = newCityData.latitude
        existingCity.longitude = newCityData.longitude
        existingCity.stateCode = newCityData.stateCode
    }
}


//MARK: - SaveCitiesToCoreData Functions
extension CoreDataService {
    private func fetchExistingCities() -> [CityModel] {
        return fetchCitiesFromCoreData() ?? []
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
                updateCityOnCoreData(existingCity, with: cityData)
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
        for idToRemove in idsToRemove {
            if let cityToRemove = uniqueExistingCities[idToRemove] {
                managedContext.delete(cityToRemove)
            }
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
