//
//  RapidManager.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 2.09.23.
//

import Foundation

enum APIError: Error {
    
}

final class RapidManager {
    
    enum RapidApi: String {
        case host = "https://wft-geo-db.p.rapidapi.com"
        case country = "/v1/geo/countries"
        case city = "/v1/geo/cities"
    }

    static let shared = RapidManager()
    
    // RapidAPI Key
    static let rapidHeaders = [
        "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com",
        "X-RapidAPI-Key": "3d736771d3msh14a3562b22f1641p1af6f7jsn1b7fcb2fc09b"
    ]
    
    private init() {}
    
    private func fetchBriefInfoOnCountry(_ name: String) async throws -> CountryBrief? {
        let query = [URLQueryItem(name: "namePrefix", value: name)]
        
        guard let url = Resource(
            host: RapidApi.host.rawValue,
            endpoint: RapidApi.country.rawValue,
            query: query
        ).url else {
            throw FetchError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = NetworkManager.shared.rapidHeaders
        
        do {
            countryBrief = try await NetworkManager.shared.fetchData(CountryBrief.self, using: request)
            return countryBrief
        } catch {
            throw FetchError.fetchError
        }
    }
    
    private func fetchDetailsInfoOnCountry() async throws {
        guard let countryId = countryBrief?.wikiDataId else {
            throw FetchError.fetchError
        }
        
        guard let url = Resource(
            host: RapidApi.host.rawValue,
            endpoint: RapidApi.country.rawValue,
            query: nil
        ).url?.appending(component: countryId)
                
        else {
            print(FetchError.invalidUrl.rawValue)
            throw FetchError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = NetworkManager.shared.rapidHeaders
        
        do {
            countryDetails = try await NetworkManager.shared.fetchData(CountryDetails.self, using: request)
        } catch {
            throw FetchError.fetchError
        }
        
    }
    
    private func fetchFlagImageData() async throws -> Data {
        guard let flagImageUrl = countryDetails?.flagImageUri else {
            throw FetchError.invalidImageUrl
        }
        
        guard let imageData = try? await NetworkManager.shared.fetchImageData(from: flagImageUrl) else {
            throw FetchError.invalidImageData
        }
        
        return imageData
    }

}
