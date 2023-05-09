//
//  Country.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 14.03.23.
//

// Minimal country info
struct CountrySearch: Decodable {
    let data: [CountryBrief]
    
    init(data: [[String: Any]]) {
        var countries = [CountryBrief]()
        
        data.forEach { keyValue in
            let country = CountryBrief(data: keyValue)
            countries.append(country)
        }
        
        self.data = countries
    }
}

struct CountryBrief: Decodable {
    let code: String?
    let currencyCodes: [String]?
    let name: String?
    let wikiDataId: String?
    
    init(data: [String: Any]) {
        code = data["code"] as? String
        currencyCodes = data["currencyCodes"] as? [String]
        name = data["name"] as? String
        wikiDataId = data["wikiDataId"] as? String
    }
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

