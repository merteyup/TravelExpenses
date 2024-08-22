//
//  AppContainer.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import Foundation
import NetworkingLayer
import CoreData

final class AppContainer {
    let router: AppRouter
    let service: NetworkingService
    let coreData: CoreDataService

    init(managedContext: NSManagedObjectContext) {
        self.router = AppRouter()
        self.service = NetworkingService()
        self.coreData = CoreDataService(context: managedContext)
    }
}

let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
let app = AppContainer(managedContext: managedContext)
