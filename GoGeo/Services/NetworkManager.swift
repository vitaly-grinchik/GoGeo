//
//  NetworkManager.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 14.03.23.
//

import Foundation

enum List: String {
    case citiesUrl = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities"
    case countriesUrl = "https://wft-geo-db.p.rapidapi.com/v1/geo/countries"
}

enum NetError: Error {
    case invalidUrl
    case invalidData
    case fileNotFound
    case imageNotFound
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    // API Key
    private let headers = [
        "X-RapidAPI-Key": "3d736771d3msh14a3562b22f1641p1af6f7jsn1b7fcb2fc09b",
        "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com"
    ]
    
    private init() {}
    
    func fetchImage(from url: String?, completion: @escaping (Result<Data, NetError>) -> Void) {
        guard let url = URL(string: List.citiesUrl.rawValue) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.imageNotFound))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
    func fetchCities() {
        
        guard let url = URL(string: List.citiesUrl.rawValue) else { return }
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
            
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let cities = try decoder.decode(City.self, from: data)
                self?.printInfoOnCities(cities.data)
                
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    private func printInfoOnCities(_ cities: [CityDetails]) {
        cities.forEach { city in
            
            let description = """
            Country:    \(city.country) (code: \(city.countryCode))
            City:       \(city.name)
            GPS:        \(city.latitude):\(city.latitude)
            ---------------------------------------------------------
            
            """
            print(description)
        }
    }
}
