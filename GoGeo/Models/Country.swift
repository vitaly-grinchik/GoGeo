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
        
        data.forEach { data in
            let country = CountryBrief(data: data)
            countries.append(country)
        }
        
        self.data = countries
    }
}

struct CountryBrief: Decodable {
    let code: String
    let currencyCodes: [String]
    let name: String
    let wikiDataId: String
    
    init(data: [String: Any]) {
        code = data["code"] as? String ?? "-"
        currencyCodes = data["currencyCodes"] as? [String] ?? ["-"]
        name = data["name"] as? String ?? "-"
        wikiDataId = data["wikiDataId"] as? String ?? "-"
    }
}

// GET Country Details request using country ID
struct CountryWithId: Decodable {
    let data: CountryDetails
    
    init(data: [String: Any]) {
        self.data = CountryDetails(data: data)
    }
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
    
    init(data: [String: Any]) {
        capital = data["capital"] as? String ?? "-"
        code = data["code"] as? String ?? "-"
        callingCode = data["callingCode"] as? String ?? "-"
        currencyCodes = data["currencyCodes"] as? [String] ?? ["-"]
        flagImageUri = data["flagImageUri"] as? String ?? "-"
        name = data["name"] as? String ?? "-"
        numRegions = data["numRegions"] as? Int ?? 0
        wikiDataId = data["wikiDataId"] as? String ?? "-"
    }
}

