//
//  CityListViewControllerBuilder.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import UIKit

final class CityListViewControllerBuilder {
    static func make() -> CityListViewController {
        let storyboard = UIStoryboard(name: "CityList", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CityListViewController") as! CityListViewController
        return viewController
    }
}
