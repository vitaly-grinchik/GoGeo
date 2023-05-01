//
//  NetworkManager.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 14.03.23.
//

import Foundation

struct Resource {
    let host: String
    let endpoint: String
    let query: [URLQueryItem]?
    
    var url: URL? {
        if var components = URLComponents(string: host) {
            components.path = endpoint
            components.queryItems = query
            if let url = components.url { return url }
        }
        return nil
    }
}

enum RapidApi: String {
    case host = "https://wft-geo-db.p.rapidapi.com"
    case country = "/v1/geo/countries"
    case city = "/v1/geo/cities"
}

enum NetError: String, Error {
    case invalidData = "Invalid data"
    case invalidUrl = "Invalid URL"
    case requestFailed = "Request failed"
    case decodeError = "JSON decoding error"
    case noImageData = "No umage data found"
}

class NetworkManager {
    static let shared = NetworkManager()
    
    // RapidAPI Key
    let rapidHeaders = [
        "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com",
        "X-RapidAPI-Key": "3d736771d3msh14a3562b22f1641p1af6f7jsn1b7fcb2fc09b"
    ]
    
    private init() {}
    
    func fetchImageData(from url: String, completion: @escaping (Result<Data, NetError>) -> Void) {
        guard let url = URL(string: url) else {
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
    
    func fetchData<T: Decodable>(_ type: T.Type, using request: URLRequest, completion: @escaping (Result<T, NetError>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                if let serverResponse = response as? HTTPURLResponse {
                    let code = serverResponse.statusCode
                    print(NetError.requestFailed.rawValue)
                    print(HTTPURLResponse.localizedString(forStatusCode: code))
                }
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                print(NetError.invalidData.rawValue)
                completion(.failure(.invalidData))
                return
            }

            if let data = try? JSONDecoder().decode(type, from: data) {
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } else {
                completion(.failure(.decodeError))
            }
        }.resume()
    }
    
}
