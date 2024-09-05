//
//  MockView.swift
//  TravelCostMVVMTests
//
//  Created by Eyup Mert on 5.09.2024.
//

import Foundation
@testable import TravelCostMVVM

final class MockView: CityListViewModelDelegate {
    
    var outputs: [CityListViewModelOutput] = []
    
    func handleViewModelOutput(_ output: TravelCostMVVM.CityListViewModelOutput) {
        outputs.append(output)
    }
    
    func navigate(to route: TravelCostMVVM.CityListViewRoute) {
        return
    }
}
