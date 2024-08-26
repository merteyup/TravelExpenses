//
//  PriceResponse.swift
//  NetworkingLayer
//
//  Created by Eyup Mert on 20.08.2024.
//

import Foundation

public struct PriceResponse: Decodable {
   public let cityId: Int?
   public let cityName: String?
   public let stateCode: String?
   public let countryName: String?
   public let exchangeRate: [String: Double]?
   public let exchangeRatesUpdated: ExchangeRatesUpdated?
   public let prices: [Price]?
   public let error: String?

    enum CodingKeys: String, CodingKey {
        case cityId = "city_id"
        case cityName = "city_name"
        case stateCode = "state_code"
        case countryName = "country_name"
        case exchangeRate = "exchange_rate"
        case exchangeRatesUpdated = "exchange_rates_updated"
        case prices
        case error
    }
}

public struct ExchangeRatesUpdated: Decodable {
   public let date: String
   public let timestamp: Int
}

public struct Price: Decodable {
  public let goodId: Int?
  public let itemName: String?
  public let categoryId: Int?
  public let categoryName: String?
  public let min: Double?
  public let avg: Double?
  public let max: Double?
  public let usd: PriceUSD?
  public let measure: String?
  public let currencyCode: String?

    enum CodingKeys: String, CodingKey {
        case goodId = "good_id"
        case itemName = "item_name"
        case categoryId = "category_id"
        case categoryName = "category_name"
        case min
        case avg
        case max
        case usd
        case measure
        case currencyCode = "currency_code"
    }
}

public struct PriceUSD: Decodable {
   public let min: String
   public let avg: String
   public let max: String
}
