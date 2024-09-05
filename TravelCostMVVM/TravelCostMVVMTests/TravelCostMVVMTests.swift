//
//  TravelCostMVVMTests.swift
//  TravelCostMVVMTests
//
//  Created by Eyup Mert on 20.08.2024.
//

import XCTest
import NetworkingLayer
import Combine
@testable import TravelCostMVVM

final class TravelCostMVVMTests: XCTestCase {
    
    private var view: MockView!
    private var viewModel: CityListViewModel!
    private var service: MockNetworkingService!
    private var coreData: MockCoreDataService!

    override func setUpWithError() throws {
        
        service = MockNetworkingService(mockResponse: mockCitiesResponse)
        coreData = MockCoreDataService(mockCities: mockCities)
        
        viewModel = CityListViewModel(networkingService: service,
                                      coreDataService: coreData)
        
        view = MockView()
        viewModel.delegate = view

    }


    func test_CityListViewControllerOutputs() throws {
        // Given
        let city1 = try ResourceLoader.loadCity(resource: .city1)
        let city2 = try ResourceLoader.loadCity(resource: .city2)
        _ = service.mockData.append(city1, city2)
                
        // When
        viewModel.loadCities()
        
        // Then
        switch try view.outputs.element(at: 0) {
        case .updateTitle(_):
            break
        default:
            XCTFail("First output should be updateTitle")
        }
        
        XCTAssertEqual(try view.outputs.element(at: 1), .setLoading(true))
        
        let expectedCities = [city1, city2].map({ CityPresentation(city: $0)})
        XCTAssertEqual(try view.outputs.element(at: 2), .showCityList(expectedCities))
        
        XCTAssertEqual(try view.outputs.element(at: 3), .setLoading(false))
    }
}
