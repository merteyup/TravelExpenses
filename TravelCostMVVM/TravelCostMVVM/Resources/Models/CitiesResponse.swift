//
//  CitiesResponse.swift
//  NetworkingLayer
//
//  Created by Eyup Mert on 20.08.2024.
//

import Foundation

public struct City: Codable {
   public let cityId: Int
   public let cityName: String
   public let countryName: String
   public let lat: Double
   public let lng: Double
   public let stateCode: String?
    
    enum CodingKeys: String, CodingKey {
        case cityId = "city_id"
        case cityName = "city_name"
        case countryName = "country_name"
        case lat
        case lng
        case stateCode = "state_code"
    }
}

public struct CitiesResponse: Decodable {
    public let cities: [CityPresentation]
    
    public enum CodingKeys: String, CodingKey {
        case cities = "cities"
    }
}
