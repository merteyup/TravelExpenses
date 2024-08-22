//
//  CityModel+CoreDataClass.swift
//  
//
//  Created by Eyup Mert on 21.08.2024.
//
//

import Foundation
import CoreData

@objc(CityModel)
public class CityModel: NSManagedObject {
    convenience init(from presentation: CityPresentation, 
                     context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.cityId = Int32(presentation.cityId)
        self.name = presentation.name
        self.countryName = presentation.countryName
        self.latitude = presentation.latitude
        self.longitude = presentation.longitude
        self.stateCode = presentation.stateCode
    }
}
