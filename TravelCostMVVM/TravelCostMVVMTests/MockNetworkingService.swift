//
//  MockNetworkingService.swift
//  TravelCostMVVMTests
//
//  Created by Eyup Mert on 5.09.2024.
//

import Foundation
import Combine
import NetworkingLayer
@testable import TravelCostMVVM

final class MockNetworkingService: NetworkingServiceProtocol {
    var mockData: AnyPublisher<Decodable, Error>
    
    init<T: Decodable>(mockResponse: T) {
        self.mockData = Just(mockResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetch<T: Decodable>(from endpoint: NetworkURL.Endpoint, responseType: T.Type) -> AnyPublisher<T, Error> {
        return mockData
            .tryMap { response in
                guard let result = response as? T else {
                    throw NSError(domain: "MockError", code: -1, userInfo: nil)
                }
                return result
            }
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }
}


func createMockCitiesResponse() -> CitiesResponse {
    return CitiesResponse(cities: [ CityPresentation(city: City(cityId: 1, cityName: "Herat", countryName: "Afghanistan", lat: 34.352865, lng: 62.20402869999999, stateCode: nil)),
                                    CityPresentation(city: City(cityId: 2, cityName: "Kabul", countryName: "Afghanistan", lat: 34.5553494, lng: 69.207486, stateCode: nil))
        
    ])
}

let mockCitiesResponse = createMockCitiesResponse()
