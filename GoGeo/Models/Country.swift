//
//  Country.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 14.03.23.
//

// GET Countries
// Minimal country info
struct CountrySearch: Decodable {
    let data: [CountryBrief]
}

struct CountryBrief: Decodable {
    let code: String
    let currencyCodes: [String]
    let name: String
    let wikiDataId: String
}

// GET Country Details request using country ID
struct CountryWithId: Decodable {
    let data: CountryDetails
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

