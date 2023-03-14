//
//  Country.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 14.03.23.
//

struct Country: Decodable {
    let data: [CountryDetails]
    let links: [Link]
    let metadata: Metadata
}

// CountryDetails: Full country details
struct CountryDetails: Decodable {
    let code: String
    let callingCode: String
    let currencyCodes: [String]
    let flagImageUri: String
    let name: String
    let numRegions: Int
    let wikiDataId: String
}
