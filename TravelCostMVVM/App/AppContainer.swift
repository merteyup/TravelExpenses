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
    let synchronizationService: SynchronizationService

    init(managedContext: NSManagedObjectContext) {
        self.router = AppRouter()
        self.service = NetworkingService()
        self.coreData = CoreDataService(context: managedContext)
        self.synchronizationService = SynchronizationService(networkingService: self.service,
                                                            coreDataService: self.coreData)
    }
}

let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
let app = AppContainer(managedContext: managedContext)
