//
//  RapidManager.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 2.09.23.
//

import Foundation

enum APIError: String, Error {
    case jsonDecodingError = "JSON decoding error"
    case jsonIncompatible = "JSON incompatibility error"
    case jsonIncompleteData = "JSON has incomplete data"
}

final class RapidManager {
    enum Endpoint: String {
        case country = "/v1/geo/countries"
        case city = "/v1/geo/cities"
    }

    static let shared = RapidManager()
    
    // RapidAPI Key
    private let rapidHeaders = [
        "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com",
        "X-RapidAPI-Key": "3d736771d3msh14a3562b22f1641p1af6f7jsn1b7fcb2fc09b"
    ]
    
    private let host = "https://wft-geo-db.p.rapidapi.com"
    
    private init() {}
    
    private func fetchBriefInfoOnCountry(_ name: String) async throws -> CountryBrief? {
        
        let countryBrief: CountryBrief?
        
        let query = [URLQueryItem(name: "namePrefix", value: name)]
        
        guard let url = URLManager(
            host: Endpoint.host.rawValue,
            endpoint: Endpoint.country.rawValue,
            query: query
        ).url else {
            throw NetworkError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = NetworkManager.shared.rapidHeaders
        
        do {
            countryBrief = try await NetworkManager.shared.fetchData(CountryBrief.self, using: request)
            return countryBrief
        } catch {
            throw NetworkError.fetchError
        }
    }
    
    private func fetchDetailsInfoOnCountry() async throws {
        guard let countryId = countryBrief?.wikiDataId else {
            throw NetworkError.fetchError
        }
        
        guard let url = URLManager(
            host: Endpoint.host.rawValue,
            endpoint: Endpoint.country.rawValue,
            query: nil
        ).url?.appending(component: countryId)
                
        else {
            print(NetworkError.invalidUrl.rawValue)
            throw NetworkError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = NetworkManager.shared.rapidHeaders
        
        do {
            countryDetails = try await NetworkManager.shared.fetchData(CountryDetails.self, using: request)
        } catch {
            throw NetworkError.fetchError
        }
        
    }
    
    private func fetchFlagImageData() async throws -> Data {
        guard let flagImageUrl = countryDetails?.flagImageUri else {
            throw NetworkError.invalidImageUrl
        }
        
        guard let imageData = try? await NetworkManager.shared.fetchImageData(from: flagImageUrl) else {
            throw NetworkError.invalidImageData
        }
        
        return imageData
    }

}
