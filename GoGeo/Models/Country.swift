//
//  Country.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 14.03.23.
//


struct CountrySearch: Decodable {
    let data: [CountryBrief]
}

struct CountryDetailsSearch: Decodable {
    let data: CountryDetails
}

// Minimal country info
struct CountryBrief: Decodable {
    let code: String
    let currencyCodes: [String]
    let name: String
    let wikiDataId: String
}

// Full country details
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
