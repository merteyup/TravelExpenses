//
//  CityModel+CoreDataProperties.swift
//  
//
//  Created by Eyup Mert on 21.08.2024.
//
//

import Foundation
import CoreData


extension CityModel {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityModel> {
        return NSFetchRequest<CityModel>(entityName: "CityModel")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var countryName: String?
    @NSManaged public var cityId: Int?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var stateCode: String?
    
    struct CitiesResponse {
        let cities: [City]
    }
    
    struct City {
        let cityId: Int
        let cityName: String
        let countryName: String
        let latitude: Double
        let longitude: Double
        let stateCode: String?
    }
}
