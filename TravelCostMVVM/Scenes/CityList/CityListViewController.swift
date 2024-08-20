//
//  CityListViewController.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import UIKit
import NetworkingLayer

final class CityListViewController: UIViewController {
    
    let service = NetworkingService()
    
    var viewModel : CityListViewModel! {
        didSet {
            // TODO: Don't forget to add self.
       //     viewModel.delegate = self
        }
    }
        override func viewDidLoad() {
        super.viewDidLoad()
    
            
            service.fetchTopCities { response in }
            
    }
    
}
