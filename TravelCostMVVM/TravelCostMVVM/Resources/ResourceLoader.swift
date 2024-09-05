//
//  ResourceLoader.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 4.09.2024.
//

import Foundation
import NetworkingLayer

class ResourceLoader {
    
    enum CityResource: String {
        case city1
        case city2
        case city3
    }
    
    static func loadCity(resource: CityResource) throws -> City {
        let bundle = Bundle.test
        let url = try bundle.url(forResource: resource.rawValue, withExtension: "json").unwrap()
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let city = try decoder.decode(City.self, from: data)
        return city
    }
}

private extension Bundle {
    class Dummy { }
    static let test = Bundle(for: Dummy.self)
}


public extension Optional {
    
    struct FoundNilWhileUnwrappingError: Error { }
    
    func unwrap() throws -> Wrapped {
        switch self {
        case .some(let wrapped):
            return wrapped
        case .none:
            throw FoundNilWhileUnwrappingError()
        }
    }
}

public extension Array {
    
    struct IndexOutOfBoundsError: Error { }
    
    func element(at index: Int) throws -> Element {
        guard index >= 0 && index < self.count else {
            throw IndexOutOfBoundsError()
        }
        return self[index]
    }
}
