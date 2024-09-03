//
//  CityDetail.swift
//  TravelCostMVVM
//
//  Created by Eyup Mert on 20.08.2024.
//

import Foundation
import NetworkingLayer

struct CityDetailPresentation: Equatable {
    let cityName: String?
    let countryName: String?
    let exchangeRate: [String: Double]?
    let exchangeRatesUpdatedDate: String?
    let exchangeRatesUpdatedTimestamp: Int?
    let prices: [PricePresentation]?
    let error: String?
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
}

extension CityDetailPresentation {
    init(city: City, cityDetails: PriceResponse.CityDetails?) {
        self.init(
            cityName: city.cityName,
            countryName: city.countryName,
            exchangeRate: cityDetails?.exchangeRate,
            exchangeRatesUpdatedDate: cityDetails?.exchangeRatesUpdatedDate,
            exchangeRatesUpdatedTimestamp: cityDetails?.exchangeRatesUpdatedTimestamp,
            prices: cityDetails?.prices?.map { PricePresentation(price: $0) },
            error: cityDetails?.error
        )
    }
}

extension PricePresentation {
    init(price: Price) {
        self.init(
            itemName: price.itemName,
            categoryName: price.categoryName,
            min: price.min,
            avg: price.avg,
            max: price.max,
            usdMin: price.usd?.min,
            usdAvg: price.usd?.avg,
            usdMax: price.usd?.max,
            measure: price.measure,
            currencyCode: price.currencyCode
        )
    }
}
