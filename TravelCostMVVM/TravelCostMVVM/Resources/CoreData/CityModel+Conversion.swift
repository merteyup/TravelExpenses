//
//  CityModel+Conversion.swift
//  
//
//  Created by Eyup Mert on 22.08.2024.
//

import Foundation
import CoreData

extension CityModel {
    static func from(cityPresentations: [CityPresentation],
                     context: NSManagedObjectContext) -> [CityModel] {
        return cityPresentations.map { presentation in
            let cityModel = CityModel(context: context)
            cityModel.cityId = Int32(presentation.cityId)
            cityModel.name = presentation.name
            cityModel.countryName = presentation.countryName
            cityModel.latitude = presentation.latitude
            cityModel.longitude = presentation.longitude
            cityModel.stateCode = presentation.stateCode
            return cityModel
        }
    }
}
