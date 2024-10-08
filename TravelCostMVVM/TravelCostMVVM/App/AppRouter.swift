//
//  AppRouter.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import UIKit

final class AppRouter {
    func start(to window: UIWindow?) {
        let viewController = CityListViewControllerBuilder.make()
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.viewModel =  CityListViewModel(networkingService: app.service, 
                                                      coreDataService: app.coreData)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
}
