//
//  City.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 13.03.23.
//

// Find cities, filtering by optional criteria. If no criteria are set, you will get back all known cities.
struct CitiesResponse: Decodable {
    let data: [CityDetails]
    let links: [Link]
    let metadata: Metadata
}

struct CityDetails: Decodable {
    let name: String
    let country: String
    let countryCode: String
    let latitude: Double
    let longitude: Double
    let population: Int
}
