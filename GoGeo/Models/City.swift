//
//  City.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 13.03.23.
//

struct City: Decodable {
    let data: [CityDetails]
    let links: [Link]
    let metadata: Metadata
}

struct CityDetails: Decodable {
    let name: String
    let country: String
    let countryCode: String
    let region: String
    let regionCode: String
    let latitude: Double
    let longitude: Double
    let population: Int
}
