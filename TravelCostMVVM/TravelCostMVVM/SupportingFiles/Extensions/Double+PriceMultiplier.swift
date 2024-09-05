//
//  Double+PriceMultiplier.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 5.09.2024.
//

import Foundation

extension Double {
    func priceMultiplier() -> Double {
        let currentPrice = self * app.globalInflation
        return currentPrice
    }
}
