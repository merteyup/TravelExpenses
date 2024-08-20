//
//  AppContainer.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import Foundation
import NetworkingLayer

let app = AppContainer()

final class AppContainer {
    let router = AppRouter()
    let service = NetworkingService()
}
