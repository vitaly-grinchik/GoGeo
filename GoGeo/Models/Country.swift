//
//  Country.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 14.03.23.
//

// Five countries list page
struct CountriesResponse: Decodable {
    let data: [Country]
    let links: [Link]
    let metadata: Metadata
}

// Minimal country info
struct Country: Decodable {
    let code: String
    let currencyCodes: [String]
    let name: String
    let wikiDataId: String
}

// CountryDetails: Full country details
struct CountryDetails: Decodable {
    let code: String
    let callingCode: String
    let currencyCodes: [String]
    let flagImageUri: String
    let name: String
    let wikiDataId: String
}
