//
//  City.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 13.03.23.
//

// Find cities, filtering by optional criteria. If no criteria are set, you will get back all known cities.

struct CityResponse: Decodable {
    let data: [Country]
}

struct City: Decodable {
    let name: String
    let country: String
    let region: String
    let regionCode: String
    let latitude: Double
    let longitude: Double
    let population: Int
}
