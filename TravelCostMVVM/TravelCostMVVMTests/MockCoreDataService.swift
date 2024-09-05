//
//  MockCoreDataService.swift
//  TravelCostMVVMTests
//
//  Created by Eyup Mert on 5.09.2024.
//

import Foundation
import Combine
@testable import TravelCostMVVM

final class MockCoreDataService: CoreDataServiceProtocol {
    private let mockCities: [CityModel]
    
    init(mockCities: [CityModel]) {
        self.mockCities = mockCities
    }
    
    func fetchCitiesFromCoreData() -> AnyPublisher<[CityModel], Error> {
        return Just(mockCities)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func saveCitiesToCoreData(from cities: [TravelCostMVVM.CityPresentation]) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func removeCitiesFromCoreData(_ remoteCities: [TravelCostMVVM.CityModel],
                                  existingCities: [TravelCostMVVM.CityModel]) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { _ in }.eraseToAnyPublisher()
    }
}

let mockCities: [CityModel] = [

]

