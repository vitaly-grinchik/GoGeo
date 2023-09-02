//
//  RapidManager.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 2.09.23.
//

import Foundation

enum APIError: String, Error {
    case invalidAPIUrl = "Invalid API Request URL"
    case jsonDecodingError = "JSON decoding error"
    case jsonIncompatible = "JSON incompatibility error"
    case jsonIncompleteData = "JSON has incomplete data"
}

final class RapidManager {
    enum Endpoint: String {
        case country = "/v1/geo/countries"
        case city = "/v1/geo/cities"
    }

    // MARK: - Shared singlton property
    static let shared = RapidManager()
    // RapidAPI Key
    
    // MARK: - Private properties
    private let networkManager = NetworkManager.shared

    private let host = "https://wft-geo-db.p.rapidapi.com"
    private let headers = [
        "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com",
        "X-RapidAPI-Key": "3d736771d3msh14a3562b22f1641p1af6f7jsn1b7fcb2fc09b"
    ]
    
    private var countryBrief: CountryBrief?
    private var countryDetails: CountryDetails?
    
    // MARK: - Init singleton
    private init() {}
    
    // MARK: - Private methods
    private func fetchBriefInfoOnCountry(_ name: String) async throws -> CountryBrief? {
        
        let countryBrief: CountryBrief?
        
        let query = [
            URLQueryItem(name: "namePrefix", value: name)
        ]
        
        guard let url = networkManager.createUrl(
            host: host,
            path: Endpoint.country.rawValue,
            query: query
        ) else {
            throw APIError.invalidAPIUrl
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        countryBrief = try await networkManager.fetchData(CountryBrief.self, using: request)
        
        return countryBrief
    }
    
    private func fetchDetailsInfoOnCountry() async throws -> CountryDetails? {
        
        guard let id = countryBrief?.wikiDataId else { throw APIError.jsonIncompleteData }
        
        guard let url = networkManager.createUrl(
            host: host,
            path: Endpoint.country.rawValue
        )?.appending(component: id)
        else {
            throw APIError.invalidAPIUrl
        }
       
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        countryDetails = try await NetworkManager.shared.fetchData(CountryDetails.self, using: request)
        
        return countryDetails
    }
    
    private func fetchFlagImageData(forCountryId id: String) async throws -> Data? {
        guard let flagImageUrl = countryDetails?.flagImageUri else {
            throw NetworkError.invalidImageUrl
        }
        
        guard let imageData = try? await NetworkManager.shared.fetchImageData(from: flagImageUrl) else {
            throw NetworkError.invalidImageData
        }
        
        return imageData
    }

}
