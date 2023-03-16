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
    case decodeError
    case noImageData
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
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidUrl))
            return
        }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noImageData))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
    func fetch<T: Decodable>(_ type: T.Type, from url: String?, completion: @escaping (Result<T, NetError>) -> Void) {
        
        // Instantiate URL
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidUrl))
            return
        }
        
        // Instantiate request
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
            
        // Instantiate session
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                completion(.failure(.invalidData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            // Parsing
            let decoder = JSONDecoder()
            do {
                let type = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
                
            } catch let error {
                completion(.failure(.decodeError))
                print(error.localizedDescription)
            }
        }.resume()
    }
}
