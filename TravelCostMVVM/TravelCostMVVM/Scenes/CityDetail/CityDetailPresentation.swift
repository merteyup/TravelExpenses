//
//  CityDetail.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import Foundation
import NetworkingLayer

final class CityDetailPresentation: Equatable {
    let cityName: String?
    let countryName: String?
    let exchangeRate: [String: Double]?
    let exchangeRatesUpdatedDate: String?
    let exchangeRatesUpdatedTimestamp: Int?
    let prices: [PricePresentation]?
    let error: String?
    
    init(from response: PriceResponse) {
        self.cityName = response.cityName
        self.countryName = response.countryName
        self.exchangeRate = response.exchangeRate
        self.exchangeRatesUpdatedDate = response.exchangeRatesUpdated?.date
        self.exchangeRatesUpdatedTimestamp = response.exchangeRatesUpdated?.timestamp
        if let pricesArray = response.prices {
            self.prices = pricesArray.compactMap { PricePresentation(from: $0) }
        } else {
            self.prices = []
        }
        self.error = response.error
    }
    
    static func == (lhs: CityDetailPresentation, rhs: CityDetailPresentation) -> Bool {
        return lhs.cityName == rhs.cityName &&
        lhs.countryName == rhs.countryName &&
        lhs.error == rhs.error &&
        lhs.exchangeRatesUpdatedDate == rhs.exchangeRatesUpdatedDate &&
        lhs.exchangeRate == rhs.exchangeRate &&
        lhs.exchangeRatesUpdatedTimestamp == rhs.exchangeRatesUpdatedTimestamp &&
        lhs.prices == rhs.prices
    }
}

struct PricePresentation: Equatable {
    let itemName: String?
    let categoryName: String?
    let min: Double?
    let avg: Double?
    let max: Double?
    let usdMin: String?
    let usdAvg: String?
    let usdMax: String?
    let measure: String?
    let currencyCode: String?
    
    init(from price: Price) {
        self.itemName = price.itemName
        self.categoryName = price.categoryName
        self.min = price.min
        self.avg = price.avg
        self.max = price.max
        self.usdMin = price.usd?.min
        self.usdAvg = price.usd?.avg
        self.usdMax = price.usd?.max
        self.measure = price.measure
        self.currencyCode = price.currencyCode
    }
}
