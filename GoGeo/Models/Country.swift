//
//  Country.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 14.03.23.
//

// Minimal country info
struct CountryBrief: Decodable {
    let code: String
    let currencyCodes: [String]
    let name: String
    let wikiDataId: String
    
    init(data: [String: Any]) {
        code = data["code"] as? String ?? "-"
        currencyCodes = data["currencyCodes"] as? [String] ?? []
        name = data["name"] as? String ?? "-"
        wikiDataId = data["wikiDataId"] as? String ?? "-"
    }
    
    static func getCountries(from data: Any) -> [CountryBrief] {
        // Check if data is JSON format compatible
        guard let jsonData = data as? [String: Any] else { return [] }
        // Check if JSON data has got data for key "data"
        guard let countries = jsonData["data"] as? [[String: Any]] else { return [] }
        
        // [String: Any] -> [CountryBrief]
        return countries.compactMap { CountryBrief(data: $0) }
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
    
    static func getCountryDetails(from data: Any) -> CountryDetails? {
        guard let data = data as? [String: Any] else { return nil }
        guard let country = data["data"] as? [String: Any] else { return nil }
        
        return CountryDetails(data: country)
    }
}
