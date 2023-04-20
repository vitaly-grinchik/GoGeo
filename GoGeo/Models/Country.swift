//
//  Country.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 14.03.23.
//

// Minimal country info
struct Country: Decodable {
    let name: String
    let wikiDataId: String
}

// CountryDetails: Full country details
struct CountryDetails: Decodable {
    let capital: String
    let code: String
    let callingCode: String
    let currencyCodes: [String]
    let flagImageUri: String
    let name: String
    let numRegions: Int
    let wikiDataId: String
}
