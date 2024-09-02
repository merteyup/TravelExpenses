//
//  CityModel+Conversion.swift
//  
//
//  Created by Eyup Mert on 22.08.2024.
//

import Foundation
import CoreData

extension CityModel {
    static func from(cityPresentations: [CityPresentation], context: NSManagedObjectContext) -> [CityModel] {
        return cityPresentations.compactMap { presentation in
            guard let cityId = presentation.cityId,
                  let name = presentation.name,
                  let countryName = presentation.countryName else {
                return nil
            }
            
            let cityModel = CityModel(context: context)
            cityModel.cityId = Int32(cityId)
            cityModel.name = name
            cityModel.countryName = countryName
            cityModel.latitude = presentation.latitude ?? 0.0
            cityModel.longitude = presentation.longitude ?? 0.0
            cityModel.stateCode = presentation.stateCode
            return cityModel
        }
    }
}
