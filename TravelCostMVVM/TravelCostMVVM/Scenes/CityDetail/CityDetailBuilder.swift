//
//  CityDetailBuilder.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import UIKit

final class CityDetailBuilder {
    static func make(viewModel: CityDetailViewModelProtocol) -> CityDetailViewController {
        let storyboard = UIStoryboard(name: "CityDetail", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CityDetailViewController") as! CityDetailViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
}
