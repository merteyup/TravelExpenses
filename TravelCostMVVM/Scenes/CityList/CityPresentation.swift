//
//  CityPresentation.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import Foundation

class CityPresentation: Equatable {
    let name: String
    
    init(title: String) {
        self.name = title
    }
    
    static func == (lhs: CityPresentation, rhs: CityPresentation) -> Bool {
        return lhs.name == rhs.name
    }
}
