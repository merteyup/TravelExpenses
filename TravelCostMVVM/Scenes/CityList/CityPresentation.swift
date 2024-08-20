//
//  CityPresentation.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import Foundation
import NetworkingLayer

class CityPresentation: Equatable {
    let cityId: Int
    let name: String
    let countryName: String
    let latitude: Double
    let longitude: Double
    let stateCode: String?
    
    init(city: City) {
        self.cityId = city.cityId
        self.name = city.cityName
        self.countryName = city.countryName
        self.latitude = city.lat
        self.longitude = city.lng
        self.stateCode = city.stateCode
    }
    
    static func == (lhs: CityPresentation, rhs: CityPresentation) -> Bool {
        return lhs.cityId == rhs.cityId
            && lhs.name == rhs.name
            && lhs.countryName == rhs.countryName
            && lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
            && lhs.stateCode == rhs.stateCode
    }
}
