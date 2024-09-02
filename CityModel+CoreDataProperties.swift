//
//  CityModel+CoreDataProperties.swift
//  
//
//  Created by Eyup Mert on 2.09.2024.
//
//

import Foundation
import CoreData


extension CityModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityModel> {
        return NSFetchRequest<CityModel>(entityName: "CityModel")
    }

    @NSManaged public var cityId: Int32?
    @NSManaged public var countryName: String?
    @NSManaged public var latitude: Double?
    @NSManaged public var longitude: Double?
    @NSManaged public var name: String?
    @NSManaged public var stateCode: String?

}
